function finalIDs = filterTrackIDsByDataFilterStruc(DataFilterStruct, SaveStructure) 
%Function that will determine the remaining track ids based on the filter
%settings set in the DataFilterWindow

    %% grab the filter
    nodes = DataFilterStruct;
    involvedIDs = {};
    %% for every node build a filter
    for i = 1:size(nodes,1)
        %{filtertype, filterprop, filterextraprop, filterminval, filtermaxval, filterlogical}
        data = nodes(i).NodeData;
        propfieldname = data{2};
        extrapropfieldname = split(data{3},".");
        %numerical data to filter for
        if size(extrapropfieldname,1) == 1
            fielddata = getfield(SaveStructure,propfieldname, extrapropfieldname{1});
        else
            fielddata = getfield(SaveStructure,propfieldname, extrapropfieldname{1},extrapropfieldname{2});
        end
        %some extra code to manage wierd data
        if propfieldname == "MeanJumpDist"
            tmpid = cell2mat(fielddata{1,1});
            tmpdat = fielddata{1,2};
            tmparray = {};
            for j = 1:size(tmpid)
                tmparray{j,1} = tmpid(j);
                tmparray{j,2} = tmpdat(j);
            end
            fielddata = tmparray;
            clear tmpid tmpdat tmparray
        end
        %need to differ between id-value and id-multiValue pairs
        multval = (cell2mat(cellfun(@(x) size(x,1),fielddata,'UniformOutput',false)));
        multval = mean(multval(:,2));
        if multval > 1 %multivalues to ids
            %need to look at every data point
            keptIDs = [];
            for k = 1:size(fielddata,1)
                tmp = fielddata(k,:);
                tmpid = tmp{1};
                tmpdat = tmp{2};
                if size(tmpdat,2) > 1
                    tmpdat = tmpdat(:,2);
                end
                %check for include exclude
                if data{1} == 1 %include
                    decisionMatrix = tmpdat >= data{4} & tmpdat <= data{5};
                else
                    decisionMatrix = tmpdat < data{4} | tmpdat > data{5};
                end
                % if all points are inculeded, take the track, if one is
                % wrong, leave it
                if decisionMatrix
                    keptIDs(end+1) = tmpid;
                end
            end
            involvedIDs{i} = {data{6}, keptIDs.'};
            clear fielddata
        else %only one value per id
            %this contains the data we want to filter
            fielddata = cell2mat(fielddata);
            %check for include exclude
            if data{1} == 1 %include
                ids = fielddata(fielddata(:,2) >= data{4} & fielddata(:,2) <= data{5},1);
            else
                ids = fielddata(fielddata(:,2) < data{4} | fielddata(:,2) > data{5},1);
            end
            involvedIDs{i} = {data{6}, ids};
        end
    end
    %%  connect the filters by their logicals
    %check that there are more then 1 connection to do
    if size(nodes,1) > 1
        startids = involvedIDs{1}{2};
        for i = 2:size(nodes,1)
            nextids = involvedIDs{i}{2};
            if involvedIDs{i}{1} == 1 %and
                Lia = ismember(startids,nextids);
                startids = startids(Lia);
            else %or
                tmp = [startids; nextids];
                startids = unique(tmp);
            end
        end
        finalIDs = startids;
    else %just one
        finalIDs = involvedIDs{1}{2};
    end
    %% return the final IDs
    finalIDs = sort(finalIDs);
end