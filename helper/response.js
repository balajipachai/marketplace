const success = (message, token) => {
    return {
        statusCode: 200,
        message,
        success: true,
        error: '',
        token
    }
}

const failure = (message) => {
    return {
        statusCode: 404,
        success: false,
        error: message
    }
}

const invalidToken = () => {
    return {
        statusCode: 401,
        success: false,
        error: message
    }
}

module.exports = {
    success, 
    failure
}