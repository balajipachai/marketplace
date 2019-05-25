const success = (message, token, layout) => {
    return {
        statusCode: 200,
        message,
        success: true,
        error: '',
        token,
        layout
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