# This file is automatically generated. Do not edit.

if Object.const_defined?('TestFlight') and !UIDevice.currentDevice.model.include?('Simulator')
  NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
  TestFlight.takeOff('d58a413e7021d4186825b4eaf8e8a831_OTU4MTIyMDEyLTA4LTI1IDE2OjMxOjUwLjYwODQxNA')
  end)
end