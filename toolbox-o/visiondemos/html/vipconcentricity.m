%% Concentricity Inspection
% This example shows how to inspect 
% the concentricity of both the core and the cladding in a cross-section of 
% optical fiber. Concentricity is a measure of how centered the core is
% within the cladding.
%
% First, the example uses the Blob Analysis block to determine the centroid 
% of the cladding. It uses this centroid to find a point on the cladding's 
% outer boundary. Using this as a starting point, the Trace Boundaries block 
% defines the cladding's outer boundary. Then the example uses these boundary 
% points to compute the cladding's center and radius using a least-square, 
% circle-fitting algorithm. If the distance between the cladding's centroid 
% and the center of its outer boundary is within a certain tolerance, the 
% fiber optic cable is in acceptable condition. 
%
% The following figure shows examples of optical fibers with good and bad 
% concentricity: 
%
% <<vipconcentricity_good_bad.png>>

% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Concentricity Inspection example model:

open_system('vipconcentricity');

%% Concentricity Inspection Results
% In the Results window, you can see that the example marked the cladding's 
% centroid with a red '+'. It marked the center of the cladding's 
% outer boundary with a green '*'. When the distance between these two 
% markers is within an acceptable tolerance, the example labels the 
% cross-section of fiber optic cable "Concentricity: Good". Otherwise, it 
% labels it "Concentricity: Bad". The example also displays the distance, 
% in pixels, between the cladding's centroid and the center of the 
% cladding's outer boundary.

close_system('vipconcentricity');
sim('vipconcentricity', 0.0333333);

set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('vipconcentricity/Results/Original');
captureVideoViewerFrame('vipconcentricity/Results/Results');

%%

close_system('vipconcentricity', 0);

