# <img src="https://github.com/hackumass/dashboard/raw/master/app/assets/images/dashboard-logo.png" height=32 alt="Dashboard Logo" /> Dashboard

<a href="https://www.youtube.com/watch?v=-QjdCGwO72M"><img src="https://i.imgur.com/k68rJJM.png" alt="Dashboard Demo Video" width=400 /></a>

Welcome to Dashboard. A Ruby on Rails web app used for registration, hardware inventory, hardware checkouts, mentorship, check in, and everything else you would need at a Hackathon. Dashboard is a highly scalable, highly modular tool, built by the [HackHer413](https://hackher413.com) and [HackUMass](https://hackumass.com) tech teams. It has been used for multiple events at UMass Amherst and has served thousands of participants in it's three year closed development cycle.

**Want to jump right in? You can begin your Dashboard journey at the [Wiki](https://github.com/hackumass/dashboard/wiki).**

# Core features

Dashboard is structured to be relatively easy to set up, while still allowing for the scalability required to run an event for over 1000 people. It's also designed to be easily customizable to the specific needs of your event.

When we say this is the _only_ platform you'll ever need, we aren't kidding. Dashboard includes all of the following functionality right out of the box.

## Account management
Email confirmation? ✅ Forgotten password? ✅ Slack integration? ✅

Jokes aside, we've put a lot of thought into the permissions and roles that we provide.
- Admins have all the permissions on the site, they can literally do everything
- Organizers are like your day of helpers, they have the ability to check participants in, and check out hardware to participants but can't touch things like the schedule or the prize listings
- Mentors have access to the mentorship dashboard where they can view, search and resolve mentorship tickets
- Atendees can view everything, and create and edit their projects & mentorship requests

## Event registration
Fully featured event applications including:
- resume PDF uploads 
- simple automatic resume verification and auto-flagging of suspicious applications
- completely customizable application questions (see [extensible options](#extensible-options))
- accept, deny, waitlist and flag applications
- fully customizable email templates for accepted, denied, and waitlisted participants (see [simple customization](#simple-customization))
- fully featured search for applications
- export applications as csv

## Event check-in
Want to know who actually showed up? We've got you covered. Each applicant recieves their own unique QR code via email, and on their dashboard home page that you can easily scan to check them into the event.

## Hardware checkout
Got your own hardware? Want to manage inventory with barcodes and check your stuff out to hackers? Remember that handy QR code? Yeah, we gotchu.

## Mentorship
Your participants need a mentor. Your mentors need to know where to go. Our simple ticket system will allow your participants to submit a request with whatever they need help with. They can even upload a screenshot or other image to help the mentors understand what's going on.

Additionally we've included a slack integration that allows mentors to click a link and directly DM the participants on slack. Just in case they're a little worn out ;)

## Schedule
We've got a fully customizable schedule baked right in. Your admins can edit it, and everyone else can see it. They even get a little preview for upcoming events on their "dashboard".

## Projects, Prizes & Judging
Devpost is great. But sometimes right before submission it can seem like their servers are just a rasberry pi cluster in your old college roommate's closet...

Worry not, we've got it all built right in. You just add the prizes you're offering via our GUI. The participants can then submit their projects and choose what prizes they want. And our platform does the rest. Assigning table numbers? ✅ Automagically printing out rubrics with their info filled in? ✅ Making sure the hacks that need power outlets can get them? ✅

You get the idea...

## Don't like it? Don't use it!
If you're feeling a little overwhelmed don't worry. We know it's a lot to transition all at once. That's why we've built in `feature flags` which allow you to turn off any of the aformentioned features. Want to use some other scheduling app? Go right ahead, you can just turn the schedule off and use the rest. No code modification required.

# Simple customization
Every hackathon is different. Each event has it's own name, location, transportation instructions, and so much more. We understand that better than anyone. After all, at UMass we use Dashboard for two different events every year. That's why we've created the `hackathon-config` submodule. It's a folder within dashboard that's actually a git repository itself. You just fork the [example config repo](https://github.com/hackumass/redpandahacks-config) and make all your changes there. Then you can keep track of any changes to your written information or configuration settings there without ever touching a line of Ruby code.

# Extensible options
With Dashboard we wanted to create an application that's not only simple to customize, but also allows you to meet the complex needs of your event. That's why you'll find countless settings within the [configuration repository](https://github.com/hackumass/redpandahacks-config). Here's just a small taste of some of the options we've included:

- Open and close applications
- Enable and disable a waitlist
- Built-in email configuration
- Slack integration
- Completely custom application questions that [you specify in YAML](https://github.com/hackumass/redpandahacks-config/blob/master/event_application.yml) and we take care of the rest

# Get started using Dashboard
To get started using Dashboard head over to the [wiki](https://github.com/hackumass/dashboard/wiki) and follow along!

## Using Dashboard?
Let us know by adding yourself to our [list of active users](https://github.com/fuseumass/dashboard/wiki/Events-using-Dashboard). Knowing that dashboard is useful to you all keeps our team extra motivated!

# Issues?
If you experience any issues or encounter any bugs, please file an issue on the GitHub [issues](https://github.com/hackumass/dashboard/issues) page.

# Contribute to Dashboard
We welcome your contributions to this open source project and we actively encourage every event who's using it to commit their tech resources to help make Dashboard better for everyone. To get started developing, head over to the [wiki](https://github.com/hackumass/dashboard/wiki) and follow the instructions for setting up the repository.

We thank you for any contributions or suggestions you have ❤️
