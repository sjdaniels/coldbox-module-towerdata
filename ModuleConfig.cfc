component {
	// Module Properties
	this.title 				= "TowerData Module";
	this.author 			= "Sean Daniels";
	this.description 		= "Module for interacting with TowerData APIs";
	this.version			= "1.0.1+0001";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "towerdata";
	// Model Namespace
	this.modelNamespace		= "towerdata";
	// CF Mapping
	this.cfmapping			= "towerdata";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= [];

	function configure(){
		// module settings - stored in modules.name.settings
		settings = {
			apiKey:""
		};
	}
}