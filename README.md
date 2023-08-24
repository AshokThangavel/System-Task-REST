## intersystems-objectscript-template
This is a template for InterSystems ObjectScript Github repository.
The template goes also with a few files which let you immediately compile your ObjectScript files in InterSystems IRIS Community Edition in a docker container

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/intersystems-community/objectscript-docker-template.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

Get System task details in REST service

Create a web application and add this dispatcher class.

List of urls
1. Get all task list
   http://server:port/webapplication/task/alltask
2. filter task details by namespace, taskname etc... (Use SYS instead of %SYS)
    http://server:port/webapplication/task/alltask/SYS
3. Get list of upcoming task details
   http://server:port/webapplication/task/upcomingtask
4. Get list of on-demand task
   http://server:port/webapplication/task/ondemandtask
5. Get entire task history
     http://server:port/webapplication/task/taskhistory
6. Get task history for specific task
   http://server:port/webapplication/task/taskhistory/taskname

Sample JSON
[
    {
        "Last Start": "2023-08-21 09:17",
        "Completed": "2023-08-21 09:17",
        "Task Name": "ExportQueryToCSV",
        "Status": "1",
        "Result": "Success",
        "Task": "1001",
        "NameSpace": "LEARNING",
        "Routine": "Samples.TaskMgr.SQLExportTask",
        "Pid": "14188",
        "%ER Date": "",
        "%ER Error #": "",
        "Username": "_SYSTEM",
        "LogDate": "2023-08-21",
        "LogTime": "33446"
    }
  ]
   
task history for specific task 
http://localhost:52773/test/task/task/taskhistory/ExportQueryToCSV
![image](https://github.com/AshokThangavel/SystemTask/assets/58914152/a9289a21-1981-46be-a3d1-ec33d1abe47b)



## How to Test it

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
