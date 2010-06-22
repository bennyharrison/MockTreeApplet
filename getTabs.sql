SELECT tt.id, tt.title FROM TreeTabs tt
WHERE tt.id IN (SELECT ownerid FROM TreeTabs_Sites
	  WHERE pubid = SessionVariables.pubid OR pubid = 0 OR pubid IS NULL)
AND tt.id IN (SELECT cs_ownerid FROM TreeTabs_Roles
	  WHERE cs_rolename IS NULL
	  		OR cs_rolename = 'Variables.roles')
