// sensing agent


/* Initial beliefs and rules */
my_group(monitoring_team).
my_scheme(monitoring_scheme).
my_role("temperature_reader").

/* Initial goals */
!start. // the agent has the goal to start

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agent believes that it can manage a group and a scheme in an organization
 * Body: greets the user
*/
@start_plan
+!start : true <-
	.print("Hello world").
	// !setup.

// +!setup: true <-
// 	lookupArtifact(OrgName, OrgArtId).

+new_organization_notification(OrgName) : true <-
	.print("Notified about new organization: ", OrgName);
	lookupArtifact(OrgName, OrgId);
	focus(OrgId).

// + artifact_org_is(OrgName) : true <-
// 	lookupArtifact(OrgName, OrgId);
// 	.print("I am in the organization ", OrgName, " with id ", OrgArtId).

// + group(GroupName,_,G)[artifact_id(OrgName)]: true <-
// 	lookupArtifact(group(GroupName,_,G), GroupId)[wsp(OrgName)];
// 	.print("I am in group ", GroupName, " in the organization ", OrgName).

/* 
 * Plan for reacting to the addition of the goal !read_temperature
 * Triggering event: addition of goal !read_temperature
 * Context: true (the plan is always applicable)
 * Body: reads the temperature using a weather station artifact and broadcasts the reading
*/


@read_temperature_plan
+!read_temperature : true <-
	.print("I will read the temperature");
	makeArtifact("weatherStation", "tools.WeatherStation", [], WeatherStationId); // creates a weather station artifact
	focus(WeatherStationId); // focuses on the weather station artifact
	readCurrentTemperature(47.42, 9.37, Celcius); // reads the current temperature using the artifact
	.print("Temperature Reading (Celcius): ", Celcius);
	.broadcast(tell, temperature(Celcius)). // broadcasts the temperature reading

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }

/* Import behavior of agents that work in MOISE organizations */
{ include("$jacamoJar/templates/common-moise.asl") }

/* Import behavior of agents that reason on MOISE organizations */
{ include("$moiseJar/asl/org-rules.asl") }

/* Import behavior of agents that react to organizational events
(if observing, i.e. being focused on the appropriate organization artifacts) */
{ include("inc/skills.asl") }