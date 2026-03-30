Magnetic Resonance Image Reconstruction Project 

  ReconMain.m - Performs MR image reconstruction on a raw data file (Pfile).

  ReconZIP4.m - Performs MR image reconstruction on a raw data file & uses zero filling to interpolate by 4.

  ReconZIP4_nograd.m -  Performs MR image reconstruction on a raw data file & uses zero filling to interpolate by 4 with no Gradwarp correction applied.

  Recon_512_Gradwarp.m - Performs MR image reconstruction on a raw data file (Pfile) & uses zero filling to interpolate by 2.

  Recon_1024_Gradwarp.m - Performs 1024×1024 MR image reconstruction on a raw data file with Gradwarp correction, using zero-padding and upsampling for interpolation.

  Recon_1024_NoGradwarp.m - Performs 1024×1024 MR image reconstruction on a raw data file without Gradwarp, using zero-padding and upsampling for interpolation.

  Recon_2048_Gradwarp.m - Performs 2048×2048 MR image reconstruction on a raw data file with Gradwarp correction, using zero-padding and upsampling for interpolation.

  Recon_2048_NoGradwarp.m - Performs 2048×2048 MR image reconstruction on a raw data file without Gradwarp, using zero-padding and upsampling for interpolation.

  carboy256 - MR raw data file (Pfile) for a 48 cm field of view scan of a carboy filled with copper sulfate solution.

  dqa256 - MR raw data file (Pfile) for a 24 cm field of view scan of the DQA3 phantom.

  P20992.7 - MR raw data from a 24x24 cm axial multiple-slice acquisition of a human volunteer using an 8-channel head coil.

  displayMagnitude.m - display log magnitude of raw data

  displayPhase.m - display phase of raw data

  fermi.m - Generates Fermi Filter used for data apodization prior to 2D FFT

  filterChannelData.m - Applies Fermi Filter & any required chopping (fftshift) to raw data

  getChannelData.m - Reads raw data and necessary parameters from Pfile

  gradwarp_2D.m - Performs 2D Gradwarp correction to improve spatial accuracy due to nonlinear gradients

  plotp.m - Plot one frame of data from a Pfile

  raw_image.m - Displays the magnitude of raw data (K-space)

  read_ge_coeff.m - Initializes spherical harmonic coefficients for gradient coils found in "gw_coils.dat"

  read_weights.m - Reads receiver channel weights from Pfile used in sum of squares coil combination.

resize_image.m - Resize image for non-symmetric acquisition sizes if necessary.

sumOfSquares.m - Multi-channel image combination using method described by Roemer

transformChannelData - Compute 2D FFT
