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
require 'redmine/i18n'
require 'time_entry'

module RedmineTimelogExtensions
    module TimeEntryPatch
        extend ActiveSupport::Concern
        included do
            before_validation :fix_values
            validates :started_on_str, :localized_time => true
            validates :ended_on_str, :localized_time => true
            validates :pause_minutes_str, :format => { :with => /([0-9]+:)?([0-9]+)/ }
            safe_attributes :started_on_str, :ended_on_str, :pause_minutes_str
            alias_method_chain :spent_on=, :redmine_timelog_extensions
        end

        module ClassMethods
        end

        module InstanceMethods
            class LocalizedTimeValidator < ActiveModel::EachValidator
                def validate_each(record, attribute, value)
                    if I18n.parse_i18n_time(value).nil? then
                        record.errors[attribute] << (options[:message] || "is not a time value (e.g. #{I18n.format_i18n_time(Time.now)})")
                    end
                end
            end

            def spent_on_with_redmine_timelog_extensions=(t)
                date = I18n.parse_i18n_date(t)

                if date.nil? then
                    self[:started_on] = nil
                    self[:ended_on] = nil
                else
                    self[:started_on] = combine_date_time(date, self.started_on)
                    self[:ended_on] = combine_date_time(date, self.ended_on)
                end

                self.spent_on_without_redmine_timelog_extensions = t
            end

            def started_on_str
                I18n.format_i18n_time(self.started_on)
            end

            def started_on_str=(t)
                time = I18n.parse_i18n_time(t)
                self[:started_on] = combine_date_time(self.spent_on, time)
            end

            def ended_on_str
                I18n.format_i18n_time(self.ended_on)
            end

            def ended_on_str=(t)
                time = I18n.parse_i18n_time(t)
                self[:ended_on] = combine_date_time(self.spent_on, time)
            end

            def pause_minutes_str
                format_duration(self.pause_minutes)
            end

            def pause_minutes_str=(t)
                self.pause_minutes = parse_duration(t)
            end

            def format_duration(d)
                "#{d.to_i / 60}:#{'%02d' % (d.to_i % 60)}"
            end

            private

            def fix_values
                puts "A----->#{self.inspect}"
                self.started_on = combine_date_time(self.spent_on, I18n.parse_i18n_time(self.started_on_str))
                self.ended_on =  combine_date_time(self.spent_on, I18n.parse_i18n_time(self.ended_on_str))
                self.pause_minutes = parse_duration(self.pause_minutes_str)

                if self.started_on.nil? or self.ended_on.nil? then
                    self.hours = nil
                else
                    self.hours = ((self.ended_on.to_f - self.started_on.to_f - (self.pause_minutes || 0).to_f * 60) / 3600.0).round(2)
                end
                puts "B----->#{self.created_on}/#{self.created_on.class}"
                puts "C----->#{self.inspect}"
                puts "D----->#{self.safe_attribute_names}"
            end

            def parse_duration(string)
                duration = nil
                if string =~ /(?:([0-9]+):)?([0-9]+)/ then
                    duration = $1.to_i * 60 + $2.to_i
                end
                duration
            end

            def combine_date_time(d, t)
                time = nil
                if not d.nil? and not t.nil? then
                    time = Time.utc(d.year, d.month, d.mday, t.hour, t.min, t.sec, t.utc_offset)
                end
                time
            end
        end
    end
end

