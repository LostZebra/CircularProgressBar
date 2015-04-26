# CircularProgressBar

A circular progressbar which is used to indicate either deterministic or non-deterministic progress behaviors.

<b>Deterministic progress behavior:</b>
Progress can be updated using a fixed percentage value.

![](https://raw.githubusercontent.com/LostZebra/CircularProgressBar/master/ForTesting/Demo/Deterministic.gif?token=AHh7kXz9X0b7PhKp19Kd8Jz2EjaOkmnMks5VRVBMwA%3D%3D)

<b>Non-deterministic progress behavior:</b>
Infinite loop animation indicating something is "In Progress".

![](https://raw.githubusercontent.com/LostZebra/CircularProgressBar/master/ForTesting/Demo/Non-deterministic.gif?token=AHh7kewPsswORLtQEbhqY0i7v_0FnY-uks5VRVCHwA%3D%3D)

## Usage
CircularProgressBar is a subclass of UIView, so it follows the normal behaviors of a UIView.
> <b>Initialization</b>

> Constructor
> ```Swift
> init?(frame: CGRect, isDeterministic: Bool = true, initialPercentage: Double? = 0.0)
> ```

> Initializa a new instance of CircularProgressBar
> ```Swift
> var circularProgressBar = CircularProgressBar(frame: CGRectMake(width / 2.0 - 40.0, height / 2.0 - 40.0, 80.0, 80.0), isDeterministic: false)
> // Deterministic
> // var circularProgressBar = CircularProgressBar(frame: CGRectMake(width / 2.0 - 40.0, height / 2.0 - 40.0, 80.0, 80.0), isDeterministic: true, initialPercentage: 30.0)
> ```

> <b>Non-deterministic progressbar</b>

> Method definition
> ```Swift
> func inProgress(progressIndicatorText: String? = "...")
> ```
> Start a new non-deterministic progress
> ```Swift
> circularProgressBar.inProgress("Loading")
> ```

> <b>Deterministic progressbar</b>

> Method definition
> ```Swift
> func updateProgress(progress: Double, animation: Bool = true)
> ```
> Start a new deterministic progress
> ```Swift
> circularProgressBar!.updateProgress(circularProgressBar!.currentPercentage! + 1.0, animation: true)
> // circularProgressBar!.updateProgress(50.0, animation: false)
> ```
