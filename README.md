# MouseTracker

## Overview	of	Function
mouseTracker	is	a	rodent	tracking	program	that	uses	background	subtraction	to	track	the	XY	pixel	coordinates	
of	a	mouse	(or	any	moving	object)	over	the	course	of	a	video.	This	is	achieved by	specifying	a	background	
frame,	subtracting	each	frame	by	the	background	frame,	and	then	identifying	the	center	of	the	largest	group	
of	pixels	that	significantly	vary	from	the	background.
On	top	of	this core	functionality,	mouseTracker	allows	for	the	setting	of	zones	within	the	video	and	for	
identifying	what	times	the	animal	is	in	the	zone,	total	time	in	the	zone,	and	number	of	entries	to	the	zone.	
Currently	only	elevated	plus	maze,	open	field,	and	three	chamber	social	zones	are	supported.	Cumulative	
distance	and	speed	over	time	are	also	calculated.

## Overview	of	use:
1. Adding mouseTracker	folder	to	matlab	path
2. Launching mouseTracker	user	interface	by	entering	mouseTrackerGUI in	the	command	window
3. Loading	video	files	to	be	tracked
4. Specifying tracker	settings	
5. Setting	Zones and	Rule	positions
6. Setting	recording	parameters
7. Selecting	Start	Tracking

### For full details please see the MouseTracker User Guide PDF file
