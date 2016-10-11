#!/bin/bash
#SBATCH -N 1
#SBATCH -t __NUM_HOURS__:00:00
#SBATCH -J __JOBNAME__
#SBATCH -A SNIC014-10-5
#SBATCH -A b2010008
#SBATCH -A b2010073
#SBATCH -p __PARTITION__
#SBATCH --mail-type=ALL
#SBATCH --mail-user=__EMAIL_ADDRESS__

echo "-------------------------------------------------------------------------"
echo "`date`: Starting job __JOBNAME__"

__CALL__
rc=$?

echo "`date`: Done __JOBNAME__, rc: $rc"
exit $rc
