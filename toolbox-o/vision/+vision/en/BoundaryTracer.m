classdef BoundaryTracer
%BoundaryTracer Trace object boundary in binary images
%   HBOUNDTRACE = vision.BoundaryTracer returns a System object,
%   HBOUNDTRACE, that traces the boundary of an object in a binary image in
%   which nonzero pixels belong to an object and zero-valued pixels
%   constitute the background.
%
%   HBOUNDTRACE = vision.BoundaryTracer('PropertyName', PropertyValue,...)
%   returns an object, HBOUNDTRACE, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   PTS = step(HBOUNDTRACE, BW, STARTPT) traces boundary of an object in
%   a binary image BW. The starting point for tracing the boundary is
%   specified by the second input matrix STARTPT, which is a two-element
%   vector of [x y] coordinates of the initial point on the object boundary.
%   The output PTS is an M-by-2 matrix of [x y] coordinates of the boundary
%   points, where M is the number of traced boundary pixels. M is less than
%   or equal to the value specified in the MaximumPixelCount property.
%
%   BoundaryTracer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create boundary tracing object with same property values
%   isLocked - Locked status (logical)
%
%   BoundaryTracer properties:
%
%   Connectivity           - Which pixels are connected to each other
%   InitialSearchDirection - First search direction to find next boundary
%                            pixel
%   TraceDirection         - Direction in which to trace the boundary
%   MaximumPixelCount      - Maximum number of boundary pixels
%
%   % EXAMPLE: Trace boundary around a coin.
%      I = imread('coins.png'); % read the image
%      hautoth = vision.Autothresholder; 
%      BW = step(hautoth, I);   % threshold the image
%      [y, x]= find(BW,1);      % select a starting point for the trace
%      % Determine the boundaries
%      hboundtrace = vision.BoundaryTracer; 
%      PTS = step(hboundtrace, BW, [x y]);
%      % Display the results
%      figure, imshow(BW); 
%      hold on; plot(PTS(:,1), PTS(:,2), 'r', 'Linewidth',2);
%      hold on; plot(x,y,'gx','Linewidth',2); % show the starting point
%
%   See also vision.EdgeDetector, vision.ConnectedComponentLabeler,
%            vision.Autothresholder.

 
%   Copyright 2008-2010 The MathWorks, Inc.

    methods
        function out=BoundaryTracer
            %BoundaryTracer Trace object boundary in binary images
            %   HBOUNDTRACE = vision.BoundaryTracer returns a System object,
            %   HBOUNDTRACE, that traces the boundary of an object in a binary image in
            %   which nonzero pixels belong to an object and zero-valued pixels
            %   constitute the background.
            %
            %   HBOUNDTRACE = vision.BoundaryTracer('PropertyName', PropertyValue,...)
            %   returns an object, HBOUNDTRACE, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   PTS = step(HBOUNDTRACE, BW, STARTPT) traces boundary of an object in
            %   a binary image BW. The starting point for tracing the boundary is
            %   specified by the second input matrix STARTPT, which is a two-element
            %   vector of [x y] coordinates of the initial point on the object boundary.
            %   The output PTS is an M-by-2 matrix of [x y] coordinates of the boundary
            %   points, where M is the number of traced boundary pixels. M is less than
            %   or equal to the value specified in the MaximumPixelCount property.
            %
            %   BoundaryTracer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create boundary tracing object with same property values
            %   isLocked - Locked status (logical)
            %
            %   BoundaryTracer properties:
            %
            %   Connectivity           - Which pixels are connected to each other
            %   InitialSearchDirection - First search direction to find next boundary
            %                            pixel
            %   TraceDirection         - Direction in which to trace the boundary
            %   MaximumPixelCount      - Maximum number of boundary pixels
            %
            %   % EXAMPLE: Trace boundary around a coin.
            %      I = imread('coins.png'); % read the image
            %      hautoth = vision.Autothresholder; 
            %      BW = step(hautoth, I);   % threshold the image
            %      [y, x]= find(BW,1);      % select a starting point for the trace
            %      % Determine the boundaries
            %      hboundtrace = vision.BoundaryTracer; 
            %      PTS = step(hboundtrace, BW, [x y]);
            %      % Display the results
            %      figure, imshow(BW); 
            %      hold on; plot(PTS(:,1), PTS(:,2), 'r', 'Linewidth',2);
            %      hold on; plot(x,y,'gx','Linewidth',2); % show the starting point
            %
            %   See also vision.EdgeDetector, vision.ConnectedComponentLabeler,
            %            vision.Autothresholder.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % 1st output - the "Pts" - connects to second input - "Start Pts"
        end

    end
    methods (Abstract)
    end
    properties
        %Connectivity Which pixels are connected to each other
        %   Specify which pixels are connected to each other as one of [4 |
        %   {8}]. Set this property to 4 to connect a pixel to the pixels on
        %   the top, bottom, left, and right. Set this property to 8 to connect
        %   a pixel to the pixels on the top, bottom, left, right, and
        %   diagonally.
        Connectivity;

        %FillValues This property will be removed in a future release
        FillValues;

        %InitialSearchDirection First search direction to find next boundary pixel
        %   Specify the first direction in which to look to find the next
        %   boundary pixel that is connected to the starting pixel. This
        %   property can be set to one of [{'North'} | 'Northeast' | 'East' |
        %   'Southeast' | 'South' | 'Southwest' | 'West' | 'Northwest'] when
        %   the Connectivity property is 8 and can be set to one of [{'North'}
        %   | 'East' | 'South' | 'West'] when the Connectivity property is 4.
        InitialSearchDirection;

        %MaximumPixelCount Maximum number of boundary pixels
        %   Specify the maximum number of boundary pixels as a scalar integer
        %   greater than 1. The object uses this value to preallocate the
        %   number of rows of the output matrix Y so that it can hold all the
        %   boundary pixel location values. The default value of this property
        %   is 500.
        MaximumPixelCount;

        %NoBoundaryAction This property will be removed in a future release
        NoBoundaryAction;

        %PixelCountOutputPort This property will be removed in a future release
        PixelCountOutputPort;

        %TraceDirection Direction in which to trace the boundary
        %   Specify the direction in which to trace the boundary as one of
        %   [{'Clockwise'} | 'Counterclockwise'].
        TraceDirection;

    end
end
