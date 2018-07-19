![nowsta](https://dka575ofm4ao0.cloudfront.net/pages-hero_covers/retina/65326/cover-bg2.png)

# Hi there! :wave:

Thanks for your interest in Nowsta :-) we really appreciate you taking the time
to work on this coding challenge for us. We expect it to take no longer than a
few hours or so, although if you choose to do all the phases it could easily
take longer.

## The task

At Nowsta, we do a whole lot with worker timecard data. Sometimes the "business
logic" in this domain is actually "legal logic", such as in the case of
calculating **overtime**.

The comprehensive solution for this problem is rather involved so we've split it
up into several phases for you. Complete as many as you'd like - getting them
all is definitely not necessary, as we prefer quality over quantity.

The goal is to write a function which takes a list of **Punchcards** (you can
assume they are all worked by the same worker), and for each punchcard, it must
set its respective regular and overtime hours worked. Each punchcard has the
following fields:

- `day` (Integer) - prepopulated (the day index that this punchcard occurred on:
  `0 = Sun, 1 = Mon, ..., 6 = Sat`)
- `week` (Integer) - prepopulated (the week index that this punchcard occurred
  on: starts at `0`, increases thereafter)
- `regular_hours` (Integer) - default `nil` (will be set by you)
- `overtime_hours` (Integer) - default `nil` (will be set by you)

One test is included to start you off, but please feel free to modify or add as
many as you'd like.

The deliverable is your fork of this repository.

## Objectives

- Use git! Please commit often so it's easy to follow your train of thought and
  iterations
- Implement as many phases as you'd like, but quality > quantity
  - The more the better, but do try to stay within the time constraint (we don't
    want to spend too much of your time). If you have to make sacrifices due to
    time, we'd prefer to see three phases done right than six hacked together.
- Make the tests pass, and add any tests to cover any change in specification
- Try to keep the code as clean, readable, and DRY as possible
- Efficiency isn't a main concern here, but a solution is certainly possible in
  `Θ(n + n log(n))` time complexity

## Running it

1.  Fork this repository to your personal GitHub account. (It's a private repo,
    so it won't show up publicly in your profile.)
2.  Run `bundle install` in this directory to install the necessary gems
    (rspec).
3.  Run `bundle exec rspec overtime_spec.rb` to run the tests (they should fail)
4.  Start with Phase 1 below to make the tests pass!

## Phase 1

The federally mandated rule for hourly-wage employees is that after an employee
works 40 hours in a week, any work that they do after that within that week must
be paid at 1.5x the regular rate.

For this example, we won't care about the rates. We just care about knowing, for
each job, how many regular and overtime hours were worked. Here's an example:

|                  | Mon | Tue | Wed | Thu | Fri | Sat | Sun | Mon (resets) |
| ---------------- | --- | --- | --- | --- | --- | --- | --- | ------------ |
| **Hours Worked** | 5   | 8   | 11  | 0   | 9   | 12  | 5   | 8            |
| Regular          | 5   | 8   | 11  | 0   | 9   | 7   | 0   | 8            |
| Overtime         | 0   | 0   | 0   | 0   | 0   | 5   | 5   | 0            |

As you can see, the first 7 hours of work done on Saturday brings the employee
to over 40 hours, and the rest of the hours worked (5) count towards overtime.
On Sunday, since the employee is already over 40 hours, all of the hours they
work count as overtime. On the next Monday, the workweek resets, and the hours
worked are counted as regular.

Implement this behavior in `overtime.rb`, making all the tests in
`overtime_spec.rb` pass.

## Phase 2

A "punchcard" can be classified as either W-2 (worked as an offical employee of
the company) or 1099 (worked as an independent contractor) (the names come from
the tax forms that those employees file with the IRS). For the purposes of this
example, 1099 jobs **do not count** at all towards overtime and themselves
**cannot have overtime hours** (only regular).

(N.B. While it's extremely uncommon that one employee works different jobs at
different tax classes, one possible scenario is when an employee switches over
from one type to another within one workweek!)

Implement and test this behavior.

## Phase 3

Some (progressive) states have additional overtime laws around how many hours is
regular to be working in a single day. A daily overtime threshold, let's say of
8 hours, requires that any work that's done after 8 hours in one day count
towards overtime.

Very important to note is that **daily overtime interacts with weekly
overtime!** The federal rule only applies when an employee works more than 40
**regular** hours in a week, meaning that with a daily threshold, hours past the
daily overtime threshold _do not_ count as hours towards the weekly overtime
threshold (since they are not regular hours).

Here's an example. Let's say you work 10 hour days four days in a row. Without
daily overtime, on the fifth day, you've already worked 40 hours in the week so
far, so any more hours would count as overtime. But, if your state has an 8 hour
daily overtime threshold, not so. This is what your hours could look like:

|                  | Mon | Tue | Wed | Thu | Fri | Sat | Sun |
| ---------------- | --- | --- | --- | --- | --- | --- | --- |
| **Hours Worked** | 10  | 10  | 10  | 10  | 5   | 10  | 4   |
| Regular          | 8   | 8   | 8   | 8   | 5   | 3   | 0   |
| Overtime         | 2   | 2   | 2   | 2   | 0   | 7   | 4   |

Note that Monday-Thursday, you actually only accrue **8 regular** (and 2
overtime) hours each day, meaning that on Friday, you've actually only worked
**32** regular hours, and so you haven't yet hit the federal weekly threshold.
Thus, the hours on Friday count as regular. Then, the first three hours on
Saturday do bring us over the weekly threshold, and so any work for the
remainder of the week thus counts as overtime.

Implement and test this behavior by allowing a user of the calculator to specify
the `double_overtime_threshold`.

## Phase 4

Some _other_ states (ahem, California) implement a **double-daily overtime**
threshold. If your state has one of, let's say 12 hours, it requires that any
work that's done after 12 hours in one day counts towards _double_-overtime (and
is paid at a 2x multiplier). This rule can only be in place with a daily
overtime rule. Here's an example, for a company with 8 hour daily overtime, and
12 hour double-daily overtime thresholds:

|                  | Mon | Tue | Wed | Thu | Fri | Sat | Sun |
| ---------------- | --- | --- | --- | --- | --- | --- | --- |
| **Hours Worked** | 9   | 12  | 14  | 5   | 7   | 6   | 13  |
| Regular          | 8   | 8   | 8   | 5   | 7   | 4   | 0   |
| Overtime         | 1   | 4   | 4   | 0   | 0   | 2   | 12  |
| Double-Overtime  | 0   | 0   | 2   | 0   | 0   | 0   | 1   |

These hours are basically treated as overtime hours (they just have a different
pay) so they don't interact with federal weekly overtime in any way different
than in Phase 3.

Implement and test this behavior by allowing a user of the calculator to specify
the `double_daily_overtime_threshold`.

## Phase 5

You're becoming an expert in overtime law! Bringing us back to the programming
world, we admit we made it a little easy for you to determine what punchcards
belong to what days and weeks. In the real world, all we know are start and end
times, so we must compute the day and week indices ourselves.

Implement and test this behavior by removing the `day` and `week` fields from
`Punchcard`, and replacing them with `start_time` and `end_time`, both Time
types. You may assume that Sunday is the first day of the week.

**Hint:** You may still keep some internal representation with the `day` and
`week` fields, which may allow you to keep your main `calculate` algorithm the
same or very similar.

**Warning!** Punchcards may span the length of a day or week! For example, if
someone works from Friday 8PM - Saturday 2 AM in one job, while they worked a
single 6 hour shift, it actually counts as 4 hours for Friday and 2 hours for
Saturday. This means someone who works a 14 hour shift may not get any overtime
at all if it falls within the right range.

## Phase 6

Here's a curveball you may have expected: the cutoff between days is actually
not always as nice as midnight.

Above, whenever it says "week" or "day", these words actually have specific
meanings that can vary from company to company. A company can decide that their
workweek starts on Tuesdays at 8 AM. A week is thus defined as a 168-hour
interval after this weekday and start hour, and a day is defined as a 24 hour
period after this start hour.

As a quick example on how this interacts with Phase 5... let's say a company
pays daily overtime at 8 hours and starts their weeks on Tuesdays, 8 AM. This
means that if someone starts a shift Friday morning at 4 AM, and works until 1
PM that day, they are not eligible for overtime because technically they worked
from 4 AM - 8 AM (4 hours) for the previous day ("Thursday"), and 8 AM - 1 PM (5
hours) for the current day (Friday).

Similarly, if someone worked 10 hours on Saturday, 10 hours on Sunday, 10 hours
on Monday, and 12 hours on Tuesday (9 AM - 9 PM), they would not qualify for any
weekly overtime because the week "cutoff" is Tuesday 8 AM -- in the first
workweek they would have worked 30 hours, and 12 so far in the second one.

Implement and test this behavior by allowing a user of the calculator to specify
the `week_start_hour` and `week_start_day`.

### Got this far? Ask us how much weirder overtime law can get ;)
