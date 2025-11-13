use std::fmt;
use std::fmt::Debug;

#[derive(Debug)]
pub struct Clock {
    hours: i32,
    minutes: i32,
}

impl Clock {
    pub fn new(hours: i32, minutes: i32) -> Self {
        let clock = Clock {
            hours: 0,
            minutes: 0,
        };
        clock.add_minutes(hours * 60).add_minutes(minutes)
    }

    pub fn add_minutes(&self, minutes: i32) -> Self {
        let minutes_in_a_day = 24 * 60;
        let new_total_minutes_after_midnight = (minutes_in_a_day
            + (self.hours * 60 + self.minutes + minutes) % minutes_in_a_day)
            % minutes_in_a_day;
        let new_minutes = new_total_minutes_after_midnight % 60;
        let hours = new_total_minutes_after_midnight / 60;

        Clock {
            hours,
            minutes: new_minutes,
        }
    }

    // pub fn to_string(&self) -> String {
    //     return "{self.hours}:{self.minutes}".to_string();
    // }
}
impl PartialEq for Clock {
    fn eq(&self, other: &Clock) -> bool {
        self.to_string() == other.to_string()
    }
}

impl fmt::Display for Clock {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:02}:{:02}", self.hours, self.minutes)
    }
}
