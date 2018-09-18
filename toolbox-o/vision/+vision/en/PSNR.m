classdef PSNR
%PSNR Peak signal-to-noise ratio
%   HPSNR = vision.PSNR returns a System object, HPSNR, that computes the
%   peak signal-to-noise ratio (PSNR) in decibels between two images. This
%   ratio is often used as a quality measurement between the original and a
%   compressed image.
%
%   Step method syntax:
%
%   Y = step(HPSNR, X1, X2) computes the peak signal-to-noise ratio, Y,
%   between images X1 and X2. The two images X1 and X2 must have the same
%   size.
%
%   PSNR methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create peak signal-to-noise ratio object with same property
%              values
%   isLocked - Locked status (logical)
%
%   This System object supports fixed-point data types.
%
%   % EXAMPLE: Use PSNR System object to compute the PSNR between an
%   %          original image and its reconstructed image.
%       hdct2d = vision.DCT;
%       hidct2d = vision.IDCT;
%       hpsnr = vision.PSNR;
%       I = double(imread('cameraman.tif'));
%       J = step(hdct2d, I);              
%       J(abs(J) < 10) = 0;
%       It = step(hidct2d, J);
%       psnr = step(hpsnr, I,It)
%       imshow(I, [0 255]), title('Original image');
%       figure, imshow(It,[0 255]), title('Reconstructed image');
%
%   See also vision.DCT, vision.IDCT.

 
%   Copyright 2003-2010 The MathWorks, Inc.

    methods
        function out=PSNR
            %PSNR Peak signal-to-noise ratio
            %   HPSNR = vision.PSNR returns a System object, HPSNR, that computes the
            %   peak signal-to-noise ratio (PSNR) in decibels between two images. This
            %   ratio is often used as a quality measurement between the original and a
            %   compressed image.
            %
            %   Step method syntax:
            %
            %   Y = step(HPSNR, X1, X2) computes the peak signal-to-noise ratio, Y,
            %   between images X1 and X2. The two images X1 and X2 must have the same
            %   size.
            %
            %   PSNR methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create peak signal-to-noise ratio object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   This System object supports fixed-point data types.
            %
            %   % EXAMPLE: Use PSNR System object to compute the PSNR between an
            %   %          original image and its reconstructed image.
            %       hdct2d = vision.DCT;
            %       hidct2d = vision.IDCT;
            %       hpsnr = vision.PSNR;
            %       I = double(imread('cameraman.tif'));
            %       J = step(hdct2d, I);              
            %       J(abs(J) < 10) = 0;
            %       It = step(hidct2d, J);
            %       psnr = step(hpsnr, I,It)
            %       imshow(I, [0 255]), title('Original image');
            %       figure, imshow(It,[0 255]), title('Reconstructed image');
            %
            %   See also vision.DCT, vision.IDCT.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
