classdef ConnectedComponentLabeler
%ConnectedComponentLabeler Label connected regions in binary image
%   ----------------------------------------------------------------------------
%   The vision.ConnectedComponentLabeler will be removed in a future release. 
%   Use the bwlabel function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
%
%   HLABEL = vision.ConnectedComponentLabeler returns a
%   System object, HLABEL, that labels and counts connected regions in a
%   binary image. The System object can output a label matrix where pixels
%   equal to 0 represent the background, pixels equal to 1 represent the
%   first object, pixels equal to 2 represent the second object, and so on.
%   The object can also output a scalar that represents the number of
%   labeled objects.
%
%   HLABEL = vision.ConnectedComponentLabeler('PropertyName',
%   PropertyValue, ...) returns a label System object, HLABEL, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   LABEL = step(HLABEL, BW) outputs the LABEL matrix for input binary
%   image BW when the LabelMatrixOutputPort property is true.
%
%   COUNT = step(HLABEL, BW) outputs the number of distinct, connected
%   regions found in input binary image BW when the LabelMatrixOutputPort
%   property is false and LabelCountOutputPort is true.
%
%   [LABEL, COUNT] = step(HLABEL, BW) outputs both the LABEL matrix and
%   connected region COUNT when both the LabelMatrixOutputPort property and
%   LabelCountOutputPort are true.
%
%   ConnectedComponentLabeler methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create label object with same property values
%   isLocked - Locked status (logical)
%
%   ConnectedComponentLabeler properties:
%
%   Connectivity          - Which pixels are connected to each other
%   LabelMatrixOutputPort - Enables output of label matrix
%   LabelCountOutputPort  - Enables output of number of labels
%   OutputDataType        - Output data type
%   OverflowAction        - Behavior if number of found objects exceeds
%                           data type size of output
%
%   % EXAMPLE: Label connected regions in an image.
%      img = logical([0 0 0 0 0 0 0 0 0 0 0 0 0; ...
%                     0 1 1 1 1 0 0 0 0 0 0 1 0; ...
%                     0 1 1 1 1 1 0 0 0 0 1 1 0; ...
%                     0 1 1 1 1 1 0 0 0 1 1 1 0; ...
%                     0 1 1 1 1 0 0 0 1 1 1 1 0; ...
%                     0 0 0 0 0 0 0 1 1 1 1 1 0; ...
%                     0 0 0 0 0 0 0 0 0 0 0 0 0])      
%      hlabel = vision.ConnectedComponentLabeler;
%      hlabel.LabelMatrixOutputPort = true;
%      hlabel.LabelCountOutputPort = false;
%      labeled = step(hlabel, img)
%
%   See also bwlabel, bwconncomp, labelmatrix 

 
%   Copyright 2008-2010 The MathWorks, Inc.

    methods
        function out=ConnectedComponentLabeler
            %ConnectedComponentLabeler Label connected regions in binary image
            %   ----------------------------------------------------------------------------
            %   The vision.ConnectedComponentLabeler will be removed in a future release. 
            %   Use the bwlabel function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            %
            %   HLABEL = vision.ConnectedComponentLabeler returns a
            %   System object, HLABEL, that labels and counts connected regions in a
            %   binary image. The System object can output a label matrix where pixels
            %   equal to 0 represent the background, pixels equal to 1 represent the
            %   first object, pixels equal to 2 represent the second object, and so on.
            %   The object can also output a scalar that represents the number of
            %   labeled objects.
            %
            %   HLABEL = vision.ConnectedComponentLabeler('PropertyName',
            %   PropertyValue, ...) returns a label System object, HLABEL, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   LABEL = step(HLABEL, BW) outputs the LABEL matrix for input binary
            %   image BW when the LabelMatrixOutputPort property is true.
            %
            %   COUNT = step(HLABEL, BW) outputs the number of distinct, connected
            %   regions found in input binary image BW when the LabelMatrixOutputPort
            %   property is false and LabelCountOutputPort is true.
            %
            %   [LABEL, COUNT] = step(HLABEL, BW) outputs both the LABEL matrix and
            %   connected region COUNT when both the LabelMatrixOutputPort property and
            %   LabelCountOutputPort are true.
            %
            %   ConnectedComponentLabeler methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create label object with same property values
            %   isLocked - Locked status (logical)
            %
            %   ConnectedComponentLabeler properties:
            %
            %   Connectivity          - Which pixels are connected to each other
            %   LabelMatrixOutputPort - Enables output of label matrix
            %   LabelCountOutputPort  - Enables output of number of labels
            %   OutputDataType        - Output data type
            %   OverflowAction        - Behavior if number of found objects exceeds
            %                           data type size of output
            %
            %   % EXAMPLE: Label connected regions in an image.
            %      img = logical([0 0 0 0 0 0 0 0 0 0 0 0 0; ...
            %                     0 1 1 1 1 0 0 0 0 0 0 1 0; ...
            %                     0 1 1 1 1 1 0 0 0 0 1 1 0; ...
            %                     0 1 1 1 1 1 0 0 0 1 1 1 0; ...
            %                     0 1 1 1 1 0 0 0 1 1 1 1 0; ...
            %                     0 0 0 0 0 0 0 1 1 1 1 1 0; ...
            %                     0 0 0 0 0 0 0 0 0 0 0 0 0])      
            %      hlabel = vision.ConnectedComponentLabeler;
            %      hlabel.LabelMatrixOutputPort = true;
            %      hlabel.LabelCountOutputPort = false;
            %      labeled = step(hlabel, img)
            %
            %   See also bwlabel, bwconncomp, labelmatrix 
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Connectivity Which pixels are connected to each other
        %   Specify which pixels are connected to each other as either 4 or 8.
        %   The default value of this property is 8. If a pixel should be
        %   connected to the pixels on the top, bottom, left, and right, set
        %   this property to 4. If a pixel should be connected to the pixels on
        %   the top, bottom, left, right, and diagonally, set this property to
        %   8.
        Connectivity;

        %LabelCountOutputPort Enables output of number of labels
        %   Set the property to true to output the number of labels. Both the
        %   LabelMatrixOutputPort and LabelCountOutputPort properties cannot be
        %   false at the same time. The default value of this property is true.
        LabelCountOutputPort;

        %LabelMatrixOutputPort Enables output of label matrix
        %   Set the property to true to output the label matrix. Both the
        %   LabelMatrixOutputPort and LabelCountOutputPort properties cannot be
        %   false at the same time. The default value of this property is true.
        LabelMatrixOutputPort;

        %OutputDataType Output data type 
        %   Set the data type of the output to one of [{'Automatic'} | 'uint32'
        %   | 'uint16' | 'uint8']. If this property is set to 'Automatic', the
        %   System object determines the appropriate data type for the output.
        %   If it is set to 'uint32', 'uint16', or 'uint8', the data type of
        %   the output is 32-, 16-, or 8-bit unsigned integers, respectively.
        OutputDataType;

        %OverflowAction Behavior if number of found objects exceeds
        %   data type size of output Specify the System object's behavior if the
        %   number of found objects exceeds the maximum number that can be
        %   represented by the output data type as one of [{'Use maximum value
        %   of the output data type'} | 'Use zero' ]. If this property is set
        %   to 'Use maximum value of the output data type', the remaining
        %   regions are labeled with the maximum value of the output data type.
        %   If this property is set to 'Use zero', the remaining regions are
        %   labeled with zeroes. This property is applicable when the
        %   OutputDataType property is 'uint16' or 'uint8'.
        OverflowAction;

    end
end
