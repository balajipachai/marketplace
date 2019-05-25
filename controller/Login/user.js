const LoginModel = require('../../model/Login/user');
const JWT = require('../../helper/jwt');
const Response = require('../../helper/response');
const ResponseMessage = require('../../apiResponses');
const Ethereum = require('../../ethereum/lib/index');
const FarmerModel = require('../../model/Farmers/index');
const DairyModel = require('../../model/DairyCompanies/index');
const VeterinariansModel = require('../../model/Veterinarians/index');
const GovernmentModel = require('../../model/Government/index');
/**
 * Function to validate user
 * @param {*} req
 * @param {*} res
 */
const login = (req, res) => {
    LoginModel.getUserPassword(req).then((password) => {
        if(LoginModel.validatePassword(req.body.email, password)){
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
};

/**
 * Function to register into the application
 * @param {*} req
 * @param {*} res
 */
const register = (req, res) => {
    LoginModel.isDuplicateEmail(req.body.email).then((valid)=> {
        return Ethereum.createAccount(req.body).then((account)=> {
            return LoginModel.storeUserDetails(req, account).then((id)=> {
                switch(req.body.userTypeId) {
                    case 1: return FarmerModel.addFarmer(req, id).then((result)=> {
                        res.send(Response.success(ResponseMessage.Register.success));
                    });
                    case 2:return DairyModel.addDairyCompany(req, id).then((result)=> {
                        res.send(Response.success(ResponseMessage.Register.success));
                    });
                    case 3:return VeterinariansModel.addVeterinarian(req, id).then((result)=> {
                        res.send(Response.success(ResponseMessage.Register.success));
                    });
                    case 4:return GovernmentModel.addGovernment(req, id).then((result)=> {
                        res.send(Response.success(ResponseMessage.Register.success));
                    })
                }

            })
        })

    }).catch((error)=> {
        res.send(Response.failure(error));
    })
};

module.exports = {
    login,
    register
};
