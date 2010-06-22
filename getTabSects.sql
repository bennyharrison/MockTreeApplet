SELECT tts.populateurl FROM TreeTabs_Sect tts
WHERE tts.ownerid = Variables.tabid
AND tts.id IN (SELECT ownerid FROM TreeTabs_Sect_Sites
	  WHERE pubid = SessionVariables.pubid OR pubid = 0 OR pubid IS NULL)
AND tts.id IN (SELECT cs_ownerid FROM TreeTabs_Sect_Roles
	  WHERE cs_rolename IS NULL
			OR cs_rolename = 'Variables.roles')
