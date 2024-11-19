import { Injectable } from "@nestjs/common";

@Injectable({})
export class AuthService {
	login() {
		return({msg : "signup"});
	}

	signup(){
		return({msg : "signin"});
	}
	
}