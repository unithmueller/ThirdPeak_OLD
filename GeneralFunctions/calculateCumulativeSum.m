function cumSum = calculateCumulativeSum(Inputarray)
%Function for cumulative addition of the values.
    sz = size(Inputarray);
    
    if sz(1) == 1
        cumSum = Inputarray;
        return
    elseif sz(1) < sz(2)
        Inputarray = Inputarray.';
    end
    cumSum = zeros(size(Inputarray,1),1);
    cumSum(1) = Inputarray(1);
    
    for i = 2:size(Inputarray,1)
        cumSum(i) = cumSum(i-1)+Inputarray(i);
    end
end