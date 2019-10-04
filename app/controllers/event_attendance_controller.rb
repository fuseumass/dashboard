class EventAttendanceController < ApplicationController
    def create
        EventAttendance.new()
    end
end
