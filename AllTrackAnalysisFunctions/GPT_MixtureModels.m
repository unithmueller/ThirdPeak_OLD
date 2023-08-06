function GPT_MixtureModels(binEdges, data, numberComponents, initialMeans, initialAmplitude, initalWidth)

% Choose the number of Gaussian components
num_components = numberComponents;

% Initialize parameters (means, amplitudes, standard deviations)
initialValues = [];
for i = 1:numberComponents
    initialValues(end+1) = initialMeans(i);
    initialValues(end+1) = initialAmplitude(i);
    initialValues(end+1) = initalWidth(i);
end
initial_params = initialValues; % Initialize for each component

% Fit GMM using fitgmdist
S = struct("mu", initialMeans, "Sigma", initialWidth);
gm = fitgmdist(data, num_components, "Start", S);

% Plot original data and GMM
figure;
histogram(data, binEdges, 'Normalization', 'pdf', 'DisplayName', 'Original Data');
hold on;

x_range = linspace(min(your_data), max(your_data), 1000);
y_fit = pdf(gm, x_range');

plot(x_range, y_fit, 'r', 'LineWidth', 2, 'DisplayName', 'GMM Fit');

for i = 1:num_components
    plot(x_range, gm.ComponentProportion(i) * normpdf(x_range, gm.mu(i), sqrt(gm.Sigma(i))), 'g--', 'LineWidth', 1, 'DisplayName', sprintf('Component %d', i));
end

hold off;
legend;
xlabel('X Position');
ylabel('Probability Density');
title('Fitting Gaussian Mixture Model');
end
