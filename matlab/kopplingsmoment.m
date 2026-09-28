function MK = kopplingsmoment(omega1)
    n_block = 3;
    mu      = 0.30;
    D_i     = 0.104;
    r_CG    = 0.043;
    R_t     = D_i / 2;
    r_b     = r_CG;
    L_c     = 0.0295;
    L_f     = 0.054;
    L_N     = 0.030;
    L_mu    = 0.034;
    m_b     = 0.079;
    F_f     = 36.561;

    if (L_N - mu * L_mu) <= 0
        error('Kopplingen självlåser! (L_N - mu*L_mu) måste vara > 0');
    end

    MK = n_block * mu * R_t * (m_b * r_b .* omega1.^2 * L_c - F_f * L_f) / (L_N - mu * L_mu);
    MK = MK .* (MK > 0);
end