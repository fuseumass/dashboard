# Clarifications #

## Hardware Inventory ##

Create/update the file `hardware_data.csv` under the directory `lib/tasks/` with the hardware items formatted like:

```csv
uid,name,count,category,location
806127238,CY8CKIT BLE-Kit ,19,Microcontrollers,1
```

After completing this step, deploy Dashboard on Heroku. On successful deployment, run bash on the specified Heroku app by,

```zsh
heroku run bash --app <app_name>
```

and run the following command inside bash,

```bash
rake hardware:create[lib/tasks/hardware_data.csv]
```

That should update the `hardware_items` PostgreSQL table and updated hardware items should be visible on Dashboard.

Note: If there are existing hardware items, remove them using `heroku pg:psql --app <app_name>` to access the Postgres instance and then run,

```psql
DELETE FROM hardware_items;
```

## Participant View [FIXED] ##

- Removed "Join the pandas" button

## Mentorship [FIXED] ##

- Converted the "Jesus take the wheel" button to "Submit Mentorship Request"

## Auto-formatting on Dashboard [IN PROGRESS] ##

**Issue Description**: Whenever an event is created, the title is formatted such that all words are of the form Xxx Xxx. One person wanted their workshop to be called LGBTea, but that reformats to Lgb Tea.

## How Judging works with Dashboard ##
