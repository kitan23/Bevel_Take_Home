Context
At Bevel, we highly value the look and feel of the app. This often requires building complex SwiftUI views with high fidelity to the design, and good code quality to make sure the look and feel is correct.
Instructions
You will receive an invite link to a Figma page with the widget design.
You will also receive a file with a MetricDataService class that you should use as the data provider for your widget.
Create a new iOS widget project and push it to a private github repo, using the provided file as the base for the widget data provider.
Complete the implementation, and push your changes to your private repository.
Reply to me (ben@bevel.health) with an invite link to your repo as well as a short video demo of the implementation once you are done.
Feel free to email me with any clarifying questions about the design or requirements.
Task
Your task is to implement a replica of the metric widget we have in our app, which is spec’ed in the provided Figma file. This metric widget has three configurations - sleep, recovery, and strain - which have different coloring, show a different score, and have different additional metrics show below.
Each widget should:
Display the score (0-100) as a percentage, with the gauge filled matching the percentage
The additional metrics associated with the score, formatted with the measurement suffix and the title of the metric
A status arrow indicating if the metric value is higher or lower than normal.
Each widget will optionally have a Target Zone property, with start and end between 0-100, which should be shown as the shaded in region in the chart gauge (shown here)
Individual Widget Configurations
Sleep (Figma)
Sleep score
Total time in bed - formatted as hours and minutes
Time asleep - formatted as hours and minutes
Recovery (Figma)
Recovery score
Heart Rate Variability (HRV) - formatted in milliseconds (ms)
Resting Heart Rate (RHR) - formatted in beats per minute (bpm)
Strain (Figma)
Strain score
Exercise Duration - formatted as hours and minutes
Calories Burned - formatted in calories (kcal)
This widget has a target zone, which is targetStrain in the data
Requirements
The implementation should display the metrics data returned from the scaffolding, it should not hardcode any values
Implementation should be pixel perfect to match the design
The code should be organized with SwiftUI best practices, as well as good abstractions and design that display good product sense
Outside of using the mock data from the provided class, the widget should be complete and built to a standard you would push to production.