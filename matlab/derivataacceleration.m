function yt = derivataacceleration(t, y)
    global eta u r JM JK1 JK2 JV1 JV2 JL
    omega1 = y(1);
    omega2 = y(2);
    omega3 = y(3);
    v      = y(4);
    s      = y(5);

    MM = motormoment(omega1);
    MK = kopplingsmoment(omega1);

    if MK > MM
        MK = MM;
    end

    ML = lastmoment(v);
    if ML / (eta * u) > MK
        ML = u * eta * MK;
    end

    if omega1 > omega2 || (omega1 == 0 && omega2 == 0)
        % Slirar
        omega1t = (MM - MK) / (JM + JK1);
        omega2t = (MK - ML / (eta * u)) / (JK2 + JV1 + (JV2 + JL) / (eta * u^2));
    else
        % Greppar
        omega1t = (MM - ML / (eta * u)) / (JM + JK1 + JK2 + JV1 + (JV2 + JL) / (eta * u^2));
        omega2t = omega1t;
    end

    omega3t = omega2t / u;
    vt      = omega3t * r;
    st      = v;

    yt = [omega1t; omega2t; omega3t; vt; st];
end