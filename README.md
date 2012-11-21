Redmine Timelog Extensions Plugin
=================================

Extends the time logs in Redmine.

Features
--------

* Adds fields for start date, end date and pause to time entries.

* Hours field is automatically calculated from these values.

Installation and Setup
----------------------

* The plugin requires at least Redmine 2.1

* Open a shell and cd into your Redmine installation directory

* Install the plugin

        cd plugins
        git clone https://github.com/jochenseeber/redmine_timelog_extensions.git
    
* Run the database migration

        RAILS_ENV=production rake redmine:plugins:migrate
    
* Restart Redmine

License
-------

This plugin is licensed under the [GNU Affero General Public License][agpl].

[agpl]: http://www.gnu.org/licenses/agpl-3.0.html "GNU Affero General Public License"
