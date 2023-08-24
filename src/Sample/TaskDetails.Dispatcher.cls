Include %occErrors

Class TaskDetails.Dispatcher Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/task/:taskType" Method="GET" Call="GetTaskDetails" Cors="true"/>
<Route Url="/task/:taskType/:searchItem" Method="GET" Call="GetTaskDetails" Cors="true"/>
</Routes>
}

ClassMethod GetTaskDetails(pTaskType As %String = "", pSearch As %String = "") As %Status
{
	#dim response As %DynamicArray = ##class(%DynamicArray).%New()
	do ##class(%REST.Impl).%SetContentType(..#CONTENTTYPEJSON)
	Try {
		set pTaskType=$$$LOWER(pTaskType)
		Set class = ..GetClassDefinition($$$LOWER(pTaskType))
		if class="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Given url is not suitable for this call"))
		}
		set query = ..GetQueryMethod(pTaskType)
		if query="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Query method is empty"))
		}
		if pSearch]"" {
			if pTaskType?1(1"alltask",1"taskhistory"){
				set result = $ClassMethod(class,query_"Func", pSearch)
			}
			else {
				$$$ThrowStatus($$$ERROR($$$GeneralError,"Search is not allowed for this url"))
			}
		}
		else {
			set result = $ClassMethod(class,query_"Func")
		}
		#;get meta details
		#dim meta As %SQL.StatementMetadata = result.%GetMetadata()
		while result.%Next() {
			set task = ##class(%DynamicObject).%New()
			for col = 1: 1: meta.columnCount {
				set column = meta.columns.GetAt(col).colName
				do task.%Set(column, $Property(result, column))
			}
			do response.%Push(task)
		}
		do ##class(%REST.Impl).%WriteResponse(response)
	}
	catch ex {
		do ##class(%REST.Impl).%WriteResponse( { "status" : 0,"error" : (ex.BinDisplayString()) })
	}
	return $$$OK
}

ClassMethod GetQueryMethod(pTaskType As %String) As %String [ CodeMode = expression ]
{
$Case($$$LOWER(pTaskType),
		"alltask" 		: "TaskListFilter",
		"taskhistory"	: "DescendingTaskHistoryFilter",
		"ondemandtask"	: "OnDemandTasksFilter",
		"upcomingtask"	: "UpcomingTasksFilter",
						: ""
	)
}

ClassMethod GetClassDefinition(pTaskType As %String = "") As %String [ CodeMode = expression ]
{
$Select(
	pTaskType= "taskhistory" : "%SYS.Task.History",
	pTaskType?1(1"alltask",1"ondemandtask",1"upcomingtask"):"%SYS.Task",		
						   1 : ""
	)
}

}
