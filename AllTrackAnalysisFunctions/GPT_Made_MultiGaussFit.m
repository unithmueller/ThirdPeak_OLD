function GPT_Made_MultiGaussFit(x_data, y_data, initial_means) % x_data: x positions of the original data
    num_gaussians = length(initial_means);
    
    % Fit Gaussian curves using lsqcurvefit
    options = optimoptions('lsqcurvefit', 'Display', 'off', 'TolFun', 1e-8); % Turn off display of iteration details
    
    % Initial parameter guesses for mean, amplitude, and standard deviation for each Gaussian
    initial_params = [];
    for i = 1:num_gaussians
        initial_params = [initial_params, initial_means(i), max(y_data) / num_gaussians, 1.0];
    end
    
    % Fit Gaussian curves using lsqcurvefit
    fitted_params = lsqcurvefit(@gaussian_curve, initial_params, x_data, y_data, [], [], options);
    
    % Plot original data and fitted Gaussian curves
    figure;
    scatter(x_data, y_data, 'b', 'Marker', 'o', 'DisplayName', 'Original Data');
    hold on;
    
    x_range = linspace(min(x_data), max(x_data), 1000);
    y_fit = gaussian_curve(fitted_params, x_range);
    
    plot(x_range, y_fit, 'r', 'LineWidth', 2, 'DisplayName', 'Fitted Gaussian Curves');
    
    for i = 1:num_gaussians
        plot(x_range, fitted_params((i - 1) * 3 + 2) * exp(-0.5 * ((x_range - fitted_params((i - 1) * 3 + 1)) ...
            ./ fitted_params((i - 1) * 3 + 3)).^2), 'g--', 'LineWidth', 1, 'DisplayName', sprintf('Gaussian %d', i));
    end
    
    hold off;
    legend;
    xlabel('X Position');
    ylabel('Y Position');
    title('Fitting Multiple Gaussian Curves');
end

function y = gaussian_curve(params, x)
    num_gaussians = numel(params) / 3;
    y = zeros(size(x));
    
    for i = 1:num_gaussians
        y = y + params((i - 1) * 3 + 2) * exp(-0.5 * ((x - params((i - 1) * 3 + 1)) ./ params((i - 1) * 3 + 3)).^2);
    end
end