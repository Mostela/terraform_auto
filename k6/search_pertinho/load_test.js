import http from 'k6/http';
import {check, group, sleep} from 'k6';
import { Trend, Gauge, Counter } from 'k6/metrics';

const list_users = [
    {"lat": "-23.3969019", "lng": "-45.8840903"},
    {'lat' : '-22.833338887315772', 'lng' : '-43.713241499999995'},
    {'lat' : '-3.1191873846684213', 'lng' : '-60.036998940277954'},
    {'lat' : '-22.9221695', 'lng' : '-43.2218887'},
    {'lat' : '-3.119114726494303', 'lng' : '-60.03702602816463'},
    {'lat' : '-23.595660688198166', 'lng' : '-46.917269610532465'},
    {'lat' : '-23.4998246', 'lng' : '-46.4005947'},
    {'lat' : '-2.501139', 'lng' : '-44.3104407'},
    {'lat' : '-22.8017792', 'lng' : '-43.639546'},
    {'lat' : '-22.8758723', 'lng' : '-43.7689665'},
    {'lat' : '-22.8644626', 'lng' : '-43.7918637'},
    {'lat' : '-22.79823394570359', 'lng' : '-43.65348853239694'},
    {'lat' : '-22.79823394570359', 'lng' : '-43.65348853239694'},
    {'lat' : '-22.877772', 'lng' : '-43.6114984'},
    {'lat' : '-2.5523866', 'lng' : '-44.241158'},
    {'lat' : '-2.5406764', 'lng' : '-44.2834646'},
    {'lat' : '-2.54067', 'lng' : '-44.283464'},
    {'lat' : '-2.5376487', 'lng' : '-44.1764237'},
    {'lat' : '-23.716247', 'lng' : '-46.6903611'},
    {'lat' : '-22.5118292', 'lng' : '-43.1776929'},
    {'lat' : '-5.9970174', 'lng' : '-49.8910276'},
    {'lat' : '-22.8654242', 'lng' : '-43.7753628'},
    {'lat' : '-6.0329211', 'lng' : '-49.8877778'},
    {'lat' : '-23.698549', 'lng' : '-46.5587696'},
    {'lat' : '-2.601077', 'lng' : '-44.13404389999999'},
    {'lat' : '-22.498039921344436', 'lng' : '-47.920801748412444'},
    {'lat' : '-22.8611186', 'lng' : '-43.7843088'},
    {'lat' : '-22.8611186', 'lng' : '-43.7843088'},
    {'lat' : '-21.9666763', 'lng' : '-52.2337184'},
    {'lat' : '-23.5651825', 'lng' : '-46.6676672'},
    {'lat' : '-22.5089278', 'lng' : '-43.1729756'},
    {'lat' : '-22.8570764', 'lng' : '-43.785795'},
    {'lat' : '-23.472066521648895', 'lng' : '-46.64890258650818'},
    {'lat' : '-21.1356135', 'lng' : '-47.8396359'},
    {'lat' : '-21.9975921', 'lng' : '-47.8781247'},
    {'lat' : '-21.9975921', 'lng' : '-47.8781247'},
    {'lat' : '-22.2949388', 'lng' : '-42.5324563'},
    {'lat' : '-22.4133585', 'lng' : '-42.9633829'},
    {'lat' : '-22.4133585', 'lng' : '-42.9633829'},
    {'lat' : '-21.7319007', 'lng' : '-42.05838860000001'},
    {'lat' : '-22.386114150054635', 'lng' : '-43.135715524209516'},
    {'lat' : '-23.6394223', 'lng' : '-46.603469'},
    {'lat' : '-23.63864877310859', 'lng' : '-46.53327159695893'},
    {'lat' : '-6.0662932', 'lng' : '-49.9080565'},
    {'lat' : '-20.3493952', 'lng' : '-43.6724391'},
    {'lat' : '-21.6466829', 'lng' : '-41.7489728'},
    {'lat' : '-22.4125882', 'lng' : '-42.9613766'},
    {'lat' : '-22.4125882', 'lng' : '-42.9613766'},
    {'lat' : '-2.5393228', 'lng' : '-44.27365959999999'},
    {'lat' : '-25.4455223', 'lng' : '-49.5290138'},
    {'lat' : '-22.4977572', 'lng' : '-43.1482265'}
]


export const options = {
    stages: [
        {duration: '5m', target: 50},
        {duration: '10m', target: 50},
        {duration: '5m', target: 0},
    ],
    thresholds: {
        checks: ['rate>0.75'],
        'http_req_failed': ['rate<0.1'],
        'http_req_duration': ['p(99)<5000'], // 99% of requests must complete below 5.0s
        'http_req_waiting': ['avg < 1500'], // avg of requests waiting must complete below 1.5s
        'content_size': ['value < 30000'],
        'count_items': ['avg > 0.90']
    },
};

const BASE_URL_HOMO = 'https://search.pertinhodecasa.com.br/sellerproducts'

const GaugeContentSize = new Gauge('content_size');
const CounterContentSize = new Trend('count_items');

export default () => {
    const about_random = () => {
        return list_users[Math.floor(Math.random() * (list_users.length - 1))];
    }

    let user_data = about_random()

    const getSellers = http.post(BASE_URL_HOMO, JSON.stringify({
            "lat": parseFloat(user_data.lat),
            "lon": parseFloat(user_data.lng),
            "payment": [],
            "category": [],
            "sub_category": [],
            "size": 20,
            "from": 0,
            "products": true,
            "search": false,
            "order_by": "score",
            "parceiro": [],
            "have_products": false
        }),
        {
            headers: {"x-api-key": "8EtPM8e4KA9SR0pIkWLeR4y0HvuX7H926gLYb7c0", "Content-Type": "application/json"}
        });

    GaugeContentSize.add(getSellers.body.length);
    if(getSellers.status === 200){
        CounterContentSize.add(JSON.parse(getSellers.json()['body'])['hits']['hits'].length)
    }


    check(getSellers, {
        'get_status': (rest) => rest.status === 200,
        'count_items_1': (rest) => JSON.parse(rest.json()['body'])['hits']['hits'].length >= 1,
        'count_items_10': (rest) => JSON.parse(rest.json()['body'])['hits']['hits'].length >= 10,
        'count_items_20': (rest) => JSON.parse(rest.json()['body'])['hits']['hits'].length >= 20,
        'timeout_elastic': (rest) => JSON.parse(rest.json()['body'])['timed_out'] !== true,
    })

    sleep(15)
};