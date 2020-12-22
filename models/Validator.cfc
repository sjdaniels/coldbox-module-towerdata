component accessors="true" implements="cbvalidation.models.validators.IValidator" hint="Validates an email address using TowerData API" singleton {

	property name="name";
    property name="TowerData" inject="TowerData@towerdata";

	Validator function init(){
		name        = "TowerDataEmailValid";
		return this;
	}

	/**
	* Will check if an incoming value validates
	* @validationResult.hint The result object of the validation
	* @target.hint The target object to validate on
	* @field.hint The field on the target object to validate on
	* @targetValue.hint The target value to validate
	* @validationData.hint The validation data the validator was created with
	*/
	boolean function validate(required any validationResult, required any target, required string field, any targetValue, any validationData, struct rules){
		// Only validate simple values and if they have length, else ignore.
		if( isSimpleValue( arguments.targetValue ) AND len( trim( arguments.targetValue ) ) ){
			local.towerResult = TowerData.validate(arguments.targetValue);
			if (local.towerResult.email_validation.status=="invalid") {
				var args = {
					message        = "The value you entered, #arguments.targetValue#, is not a valid email address: #TowerData.getStatusCodes()[local.towerResult.email_validation.status_code].description#",
					field          = arguments.field,
					validationType = getName(),
					validationData = arguments.validationData,
					rejectedValue  = arguments.targetValue,
				};
				validationResult.addError( validationResult.newError( argumentCollection=args ).setErrorMetadata({ "details":TowerData.getStatusCodes()[local.towerResult.email_validation.status_code].description }) );
				return false;
			}
		}

		return true;
	}

	/**
	* Get the name of the validator
	*/
	string function getName(){
		return name;
	}

}