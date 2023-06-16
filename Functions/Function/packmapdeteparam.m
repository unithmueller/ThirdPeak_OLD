function params = packmapdeteparam(app)
    params.Velothresh = app.VelocitythresholdmsEditField.Value;
    params.Algo = app.AlgorithmDropDown.Value;
    params.Maxclusterp = app.MaxclusterpointsEditField.Value;
    params.Startcore = app.StartcoredistanceEditField.Value;
    params.Stepcore = app.StepcoredistanceEditField.Value;
    params.Endcore = app.EndcoredistanceEditField.Value;
    params.Startnumneighbp = app.StartnumneighbpointsEditField.Value;
    params.Stepnumneigh = app.StepnumneighbpointsEditField.Value;
    params.Endnumneigh = app.EndnumneighbpointsEditField.Value;
    params.Nodeshape = app.NodesshapeDropDown.Value;
    params.Minareeps = app.MinareaepsilonEditField.Value;
    params.Minnodearea = app.MinnodeareaEditField.Value;
    params.Maxnodearea = app.MaxnodeareaEditField.Value;
end
    