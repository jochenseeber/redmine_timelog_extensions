#
# Copyright 2012 Jochen Seeber
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
module RedmineTimelogExtensions
    class IssueHooks < Redmine::Hook::ViewListener
        render_on :view_issues_edit_notes_bottom, :partial => 'issues/timelog_extension_fields'
        def controller_issues_edit_before_save(context)
            params = context[:params][:time_entry]
            time_entry = context[:time_entry]
            if not time_entry.nil? and not context.nil? then
                time_entry.started_on_str = params[:started_on]
                time_entry.ended_on_str = params[:ended_on]
                time_entry.pause_minutes_str = params[:pause_minutes]
            end
        end
    end
end
