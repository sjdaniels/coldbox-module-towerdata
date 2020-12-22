component {
	processingdirective preserveCase=true;

	property name="settings" inject="coldbox:moduleSettings:towerdata";

	public any function init() {
		return this;
	}

	public struct function validate(required string email, numeric timeout=10){
		var cfhttp = {}
		http url="https://api.towerdata.com/v5/ev" method="get" {
			httpparam type="url" name="email" value="#arguments.email#";
			httpparam type="url" name="timeout" value="#arguments.timeout#";
			httpparam type="url" name="api_key" value="#settings.apiKey#";
		}

		var result = parseResponse(cfhttp);
		return result;
	}

	private any function parseResponse(required struct response) {
		var exception = { type:"TowerData.Email" }

		if (arguments.response.status_code neq 200) {
			exception.message = "API Returned Error"
			exception.detail = arguments.response.filecontent;
			throw(argumentCollection:exception);
		}

		try {
			var apiResult = deserializeJSON(arguments.response.filecontent);
		} catch (Any e) {
			exception.message = "Deserialization Error"
			exception.detail = serializeJSON(arguments.response);
			throw(argumentCollection:exception);
		}

		return apiResult;
	}

	public struct function getStatusCodes() {
		 return [
			 "5":	{description:"Timeout. Did not get a response in time.", type:"unknown"}
			,"10":	{description:"Syntax OK.", type:"unknown"}
			,"20":	{description:"Syntax OK and the domain is valid.", type:"unknown"}
			,"45":	{description:"Domain is a catch all and does not support validation.", type:"unverifiable"}
			,"50":	{description:"Valid email address.", type:"valid"}
			,"100":	{description:"General syntax error.", type:"invalid"}
			,"110":	{description:"Invalid character in address.", type:"invalid"}
			,"115":	{description:"Invalid domain syntax.", type:"invalid"}
			,"120":	{description:"Invalid username syntax.", type:"invalid"}
			,"125":	{description:"Invalid username syntax for that domain.", type:"invalid"}
			,"130":	{description:"Address is too long.", type:"invalid"}
			,"135":	{description:"Address has unbalanced parentheses.", type:"invalid"}
			,"140":	{description:"Address doesn’t have a username.", type:"invalid"}
			,"145":	{description:"Address doesn’t have a domain.", type:"invalid"}
			,"150":	{description:"Address doesn’t have an @ sign.", type:"invalid"}
			,"155":	{description:"Address has more than one @ sign.", type:"invalid"}
			,"200":	{description:"Invalid top-level domain (TLD) in address.", type:"invalid"}
			,"205":	{description:"IP address is not allowed as a domain.", type:"invalid"}
			,"210":	{description:"Address contains an extra space or character.", type:"invalid"}
			,"215":	{description:"Unquoted spaces not allowed in email addresses.", type:"invalid"}
			,"310":	{description:"Domain doesn’t exist.", type:"invalid"}
			,"315":	{description:"Domain doesn’t have a valid IP address.", type:"invalid"}
			,"325":	{description:"Domain can’t receive email.", type:"invalid"}
			,"400":	{description:"Mailbox doesn't exist.", type:"invalid"}
			,"410":	{description:"The mailbox is full and can’t receive email.", type:"invalid"}
			,"420":	{description:"Mail isn't accepted for this domain.", type:"invalid"}
			,"500":	{description:"Emails with that username aren’t accepted.", type:"invalid"}
			,"505":	{description:"Emails with that domain aren’t accepted.", type:"invalid"}
			,"510":	{description:"That address isn’t accepted.", type:"invalid"}
			,"520":	{description:"Address matched to known bouncers.", type:"invalid"}
			,"525":	{description:"Address is a spamtrap, a known complainer or is suppressed.", type:"risky"}
			,"530":	{description:"Address has opted out from commercial email.", type:"risky"}
			,"999":	{description:"System error.", type:"unknown"}
		 ];
	} 

	public struct function getDomainTypes() {
		return [
			 "biz":"The domain of a company."
			,"disposable":"Disposable domain."
			,"edu":"An educational institution."
			,"freeisp":"Free ISP (internet service provider)."
			,"gov":"A government institution."
			,"org":"A non-profit organization."
			,"paidisp":"Paid ISP."
			,"parked":"The domain does not have an active website."
			,"wireless":"Wireless domain. Do not send unsolicited emails."
		];
	}
}