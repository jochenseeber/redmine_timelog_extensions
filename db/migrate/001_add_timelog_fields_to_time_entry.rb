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
class AddTimelogFieldsToTimeEntry < ActiveRecord::Migration
    def self.up
        change_table :time_entries do |t|
            t.datetime :started_on
            t.datetime :ended_on
            t.integer :pause_minutes, :precision => 3, :scale => 0
        end
    end

    def self.down
        change_table :time_entries do |t|
            t.remove :started_on
            t.remove :ended_on
            t.remove :pause_minutes
        end
    end
end