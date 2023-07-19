function destinationStruc = calculateJumpAngles(SingleTrackData, destinationStruc)
%Function to calculate the jump angles between steps. Will save the
%calculated data into the given destination structure.
%Input: SingleTrackData - coordinates of a single track
       %destinationStruc - stucture to save to
%Output:
    %% Set the temporary save structures
    stepNumber = size(SingleTrackData,1)-2;
    anglesxy = zeros(stepNumber,1);
    anglesxyz = zeros(stepNumber,1);
    
    %% calculate the angles
    for i = 1:stepNumber
        %Need 3 points to calculate an angle                
        p1xyz = SingleTrackData(i,3:5);
        p2xyz = SingleTrackData(i+1,3:5);
        p3xyz = SingleTrackData(i+2,3:5);
        %flatten for 2d
        p1xy = p1xyz;
        p1xy(3) = 0;
        p2xy = p2xyz;
        p2xy(3) = 0;
        p3xy = p3xyz;
        p3xy(3) = 0;
        %calculate the vectors
        uxy = p2xy-p1xy;
        uxyz = p2xyz-p1xyz;
        vxy = p3xy-p2xy;
        vxyz = p3xyz-p2xyz;
        %calculate the angle
        anglesxy(i) = atan2(norm(cross(uxy,vxy)),dot(uxy,vxy));
        anglesxyz(i) = atan2(norm(cross(uxyz,vxyz)),dot(uxyz,vxyz));
    end
    
    %% convert the angle into degree
    anglesxy = rad2deg(anglesxy);
    anglesxyz = rad2deg(anglesxyz);
    
    %save the angles
    destinationStruc.JumpAngles.XY(end+1,:) = {SingleTrackData(1,1), anglesxy};
    destinationStruc.JumpAngles.XYZ(end+1,:) = {SingleTrackData(1,1), anglesxyz};
end