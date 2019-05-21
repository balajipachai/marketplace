const LoginModel = require('../../model/Login/user');
const JWT = require('../../helper/jwt');
const Response = require('../../helper/response');
const ResponseMessage = require('../../apiResponses');
const Ethereum = require('../../ethereum/lib/index')
/**
 * Function to validate user
 * @param {*} req 
 * @param {*} res 
 */
const login = (req, res) => {
    LoginModel.getUserPassword(req).then((password) => {
        if(LoginModel.validatePassword(req.body.username, password)){
            return LoginModel.getUserDetails(req).then((user)=> {
                return JWT.createToken(user).then((token)=> {
                    res.send(Response.success(ResponseMessage.Login.success, token));
                })
            })
        }
        else {
            res.send(Response.failure(ResponseMessage.Login.invalidPassword));
        }
    }).catch((error)=> {
        res.send(Response.failure(ResponseMessage.Login.invalidEmail));
    })
}

/**
 * Function to register into the application
 * @param {*} req 
 * @param {*} res 
 */
const register = (req, res) => {
    LoginModel.isDuplicateUsername(req.body.username).then((valid)=> {
        return Ethereum.createAccount(req.body).then((account)=> {
            return LoginModel.storeUserDetails(req, account).then((result)=> {
                res.send(Response.success(ResponseMessage.Login.success, token));
            })
        })
            
    }).catch((error)=> {
        res.send(Response.success(ResponseMessage.Login.success, token));
    })
}

module.exports = {
    login,
    register
}