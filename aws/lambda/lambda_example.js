exports.handler = async (event) => {
    // TODO implement
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello, I am Lambda Server!!'),
    };
    return response;
};
