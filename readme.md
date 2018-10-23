![nowsta](https://dka575ofm4ao0.cloudfront.net/pages-hero_covers/retina/65326/cover-bg2.png)

# Hi there! :wave:

Thanks for your interest in Nowsta :-) we really appreciate you taking the time
to work on this coding challenge for us. We expect it to take no longer than a
few hours max.

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

The deliverable is your fork of this repository (no need to create a PR), or zip
up your solution and send it via email.

## Objectives

- Use git! Please commit often so it's easy to follow your train of thought and
  iterations
- Implement as many phases as you'd like, but quality > quantity!
- Make the tests pass, and add any tests to cover any change in specification
- Try to keep the code as clean, readable, and DRY as possible
- Efficiency isn't a main concern here, but a solution is certainly possible in
  `Θ(n + n log(n))` time complexity

## Running it

1.  Fork this repository to your personal GitHub account. (It's a private repo,
    so it won't show up publicly in your profile.) Or, just clone it locally.
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

### Got this far? Ask us how much weirder overtime law can get ;)
