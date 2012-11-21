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
    module I18nPatch
        extend ActiveSupport::Concern
        module InstanceMethods
        end

        module ClassMethods
            #
            # Parse a time string using a specific format
            #
            # str:: String to parse
            # format:: see strptime[http://pubs.opengroup.org/onlinepubs/007904975/functions/strptime.html].
            #
            def parse_i18n_time_with_format(str, format)
                time = nil
                if not str.nil? then
                    if str.instance_of?(Time) then
                        # Already a time: Just return it
                        time = str
                    elsif str.instance_of?(String) then
                        # A String: Parse it using the supplied format
                        begin
                            time = DateTime.strptime(str, format).to_time

                            if time.utc? then
                                # If we parsed a UTC time, adjust to user's time zone
                                tz = User.current.time_zone
                                if not tz.nil? then
                                    # User time zone set: Adjust
                                    time -= tz.utc_offset
                                end
                            end
                        rescue
                            # Could not parse string: return nil
                            time = nil
                        end
                    end
                end

                time
            end

            #
            # Convert a time to a string using a specific format
            #
            # time:: Time to convert
            # format:: see strptime[http://pubs.opengroup.org/onlinepubs/007904975/functions/strptime.html].
            #
            def format_i18n_time_with_format(time, format)
                str = nil
                if not time.nil? then
                    tz = User.current.time_zone
                    if not tz.nil? then
                        # The user has a time zone: adjust the UTC time to this time zone
                        time += tz.utc_offset
                    end
                    # Format the time
                    str = time.to_time.strftime(format)
                end
                str
            end

            def parse_i18n_time(str)
                parse_i18n_time_with_format(str, i18n_time_format)
            end

            def format_i18n_time(time)
                format_i18n_time_with_format(time, i18n_time_format)
            end

            def i18n_time_format
                Setting.time_format.blank? ? I18n.t('time.formats.time') : Setting.time_format
            end

            def parse_i18n_date(str)
                parse_i18n_time_with_format(str, i18n_date_format)
            end

            def format_i18n_date(date)
                format_i18n_time_with_format(date, i18n_date_format)
            end

            def i18n_date_format
                Setting.date_format.blank? ? I18n.t('time.formats.default') : Setting.date_format
            end
        end
    end
end