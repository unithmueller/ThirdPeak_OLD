function err = fitblackbody(lambda,wavelength,y,handle)




emissivity = radiance'\y';
z = radiance*emissivity;
err = norm(z-y);