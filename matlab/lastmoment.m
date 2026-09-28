function ML = lastmoment(v)
    global f m g c rho A r
    Frull = f * m * g;
    Fluft = 0.5 * c * rho * A * v.^2;
    ML = (Frull + Fluft) * r;
end