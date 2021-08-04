package de.cau.cs.kieler.spviz.spviz.generator

import de.cau.cs.kieler.spviz.spviz.sPViz.SPViz
import java.util.ArrayList
import java.util.LinkedHashMap
import de.cau.cs.kieler.spviz.spvizmodel.sPVizModel.Artifact

/**
 * Simplifies access to the data in a SPViz representation
 */
class DataAccess {
	final String packageName
	final String importedNamespace
	final String visualizationName
	final String projectName
	final String[] artifacts
	final String[] overviews
	final LinkedHashMap<String, ArrayList<String[]>> requiredArtifacts
	final LinkedHashMap<String, ArrayList<String[]>> requiringArtifacts
	final LinkedHashMap<String, String[]> artifactsInOverviews
	final LinkedHashMap<String, ArrayList<String[]>> overviewContentConnections
	
	/**
	 * Creates a DataAccess Object for a more convenient access to the data
	 * contained within the given {@link SPViz} model via class methods.
	 * 
	 * @param spviz
	 * 		a SPViz containing the required data
	 */
	new (SPViz spviz) {
		packageName = spviz.package
		importedNamespace = spviz.importedNamespace
		visualizationName = spviz.name
		projectName = visualizationName.replace("Viz", "Project")
		requiredArtifacts = newLinkedHashMap
		requiringArtifacts = newLinkedHashMap
		artifactsInOverviews = newLinkedHashMap
		overviewContentConnections = newLinkedHashMap
		
		val ArrayList<String> artifactList = newArrayList()
		overviews = newArrayOfSize(spviz.views.size);
		
		for(var i=0; i<spviz.views.size; i++) {
			val view = spviz.views.get(i)
			overviews.set(i, view.name)
			val String[] shownElements = newArrayOfSize(view.shownElements.size)
			
			// find all artifacts shown in an overview
			for(var j=0; j<view.shownElements.size; j++){
				val artifactName = view.shownElements.get(j).shownElement.name
				shownElements.set(j, artifactName)
				if (!artifactList.contains(artifactName)) artifactList.add(artifactName)
			}
			artifactsInOverviews.put(view.name, shownElements)
		
			// find all connections between artifacts
			for(var j=0; j<view.shownConnections.size; j++) {
				val connection = view.shownConnections.get(j).shownConnection
				val connectionName = connection.name
				val requiring = (connection.eContainer as Artifact).name
				val required = connection.dependsOn.name
				
				if(requiredArtifacts.containsKey(requiring)) {
					requiredArtifacts.get(requiring).add(#[connectionName, required])
				} else {
					val ArrayList<String[]> requiredConnections = newArrayList
					requiredConnections.add(#[connectionName, required])
					requiredArtifacts.put(requiring, requiredConnections)
				}
				
				if(requiringArtifacts.containsKey(required)) {
					requiringArtifacts.get(required).add(#[connectionName, requiring])
				} else {
					val ArrayList<String[]> requiredConnections = newArrayList
					requiredConnections.add(#[connectionName, requiring])
					requiringArtifacts.put(required, requiredConnections)
				}
				
				if(overviewContentConnections.containsKey(view.name)) {
					overviewContentConnections.get(view.name).add(#[connectionName, requiring, required])
				} else {
					val ArrayList<String[]> contentConnections = newArrayList
					contentConnections.add(#[connectionName, requiring, required])
					overviewContentConnections.put(view.name, contentConnections)
				}
				
				// catch artifacts, which are only stated in the SPVizModel or inside a connection
				if(!artifactList.contains(requiring)) artifactList.add(requiring)
				if(!artifactList.contains(required)) artifactList.add(required)
			}
		}
		
		artifacts = newArrayOfSize(artifactList.size)
		for(var i=0; i<artifactList.size; i++) {
			artifacts.set(i, artifactList.get(i))
		}
	}
	
	/** @return package name */
	def String getPackageName () { return packageName }
	/** @return package name of the model */
	def String getImportedNamespace () { return importedNamespace }
	/** @return name of the visualisation */
	def String getVizName () { return visualizationName }
	/** @return name of the project */
	def String getProjectName () { return projectName }
	/** @return all overview names as a string array */
	def String[] getOverviews () { return overviews }
	/** @return all artifact names as a string array */
	def String[] getArtifacts () { return artifacts }
	
	/** 
	 * Returns all required artifacts for a given artifact. 
	 * 
	 * @param requiring
	 * 		the artifact which requires other artifacts
	 * @return
	 * 		List of the required artifact names
	 */
	def ArrayList<String[]> getRequiredArtifacts (String requiring) { 
		if (!requiredArtifacts.containsKey(requiring)) {
			return newArrayList
		}
		return requiredArtifacts.get(requiring)
	}
	
	/** 
	 * Returns all requiring artifacts for a given artifact. 
	 * 
	 * @param required
	 * 		the artifact which is required by other artifacts
	 * @return
	 * 		List of the requiring artifact names
	 */
	def ArrayList<String[]> getRequiringArtifacts (String required) {
		if (!requiringArtifacts.containsKey(required)) {
			return newArrayList
		}
		return requiringArtifacts.get(required)
	}
	
	/** 
	 * Returns all required artifacts for a given artifact, if the connection
	 * is displayed. 
	 * 
	 * @param requiring
	 * 		the artifact which requires other artifacts
	 * @return
	 * 		List of the required artifact names
	 */
	def ArrayList<String[]> getRequiredArtifactsInOverview (String requiring, String overview) { 
		val ArrayList<String[]> requiredPairs = newArrayList
		if (!requiredArtifacts.containsKey(requiring)) {
			return requiredPairs
		}
		for(requiredConnectionNameAndArtifact : requiredArtifacts.get(requiring)) {
			val String[] connection = newArrayOfSize(3)
			connection.set(0, requiredConnectionNameAndArtifact.get(0))
			connection.set(1, requiring)
			connection.set(2, requiredConnectionNameAndArtifact.get(1))
			if(isConnectionDisplayedInOverview(overview, connection)) {
				requiredPairs.add(requiredConnectionNameAndArtifact)
			}
		}
		return requiredPairs
	}
	
	/** 
	 * Returns all requiring artifacts for a given artifact, if the connection
	 * is displayed. 
	 * 
	 * @param required
	 * 		the artifact which is required by other artifacts
	 * @return
	 * 		List of the requiring artifact names
	 */
	def ArrayList<String[]> getRequiringArtifactsInOverview (String required, String overview) {
		val ArrayList<String[]> requiringPairs = newArrayList
		if (!requiringArtifacts.containsKey(required)) {
			return requiringPairs
		}
		for(requiringConnectionNameAndArtifact : requiringArtifacts.get(required)) {
			val String[] connection = newArrayOfSize(3)
			connection.set(0, requiringConnectionNameAndArtifact.get(0))
			connection.set(1, requiringConnectionNameAndArtifact.get(1))
			connection.set(2, required)
			if(isConnectionDisplayedInOverview(overview, connection)) {
				requiringPairs.add(requiringConnectionNameAndArtifact)
			}
		}
		return requiringPairs
	}
	
	/** 
	 * Returns all shown artifacts for an overview. 
	 * 
	 * @param overviewName
	 * 		overview name as a string
	 * @return
	 * 		List of the artifacts shown in an overview
	 */
	def String[] getDisplayedArtifacts (String overviewName) { 
		if (!artifactsInOverviews.containsKey(overviewName)) {
			return #[]
		}
		return artifactsInOverviews.get(overviewName)
	}
	
	/** 
	 * Returns all connection shown in an overview. 
	 * 
	 * @param overviewName
	 * 		overview name as a string
	 * @return
	 * 		List of connections shown in an overview.
	 * 		A connection is a tupel of strings:
	 * 			[connection name, requiring artifact name, required artifact name]
	 */
	def ArrayList<String[]> getOverviewConnections (String overviewName) {
		if (!overviewContentConnections.containsKey(overviewName)) {
			return newArrayList
		}
		return overviewContentConnections.get(overviewName)
	}
	
	/** 
	 * Finds for a given artifact the overview, it is contained in. 
	 * 
	 * @param artifact
	 * 		artifact name as a string
	 * @return
	 * 		an overview as a string
	 */
	def String getOverview (String artifact) {
		for(overview : overviews) {
			for(overviewArtifact : getDisplayedArtifacts(overview)) {
				if(overviewArtifact == artifact) return overview
			}
		}
		System.out.println("artifact "+ artifact +" not found in any overview")
		return ""
	}
	
	def boolean isConnectionDisplayedInOverview(String overview, String[] connection){
		for(overviewConnection : getOverviewConnections(overview)) {
			if(overviewConnection.get(0) == connection.get(0)
				&& overviewConnection.get(1) == connection.get(1)
				&& overviewConnection.get(2) == connection.get(2) 
			) {
				return true
			}
		}
		return false
	}
	
}
