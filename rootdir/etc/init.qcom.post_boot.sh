#!/system/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`

case "$target" in
    "msm8916")
        # Change PM debug parameters permission
        chown -h radio.system /sys/module/qpnp_power_on/parameters/reset_enabled
        chown -h radio.system /sys/module/qpnp_power_on/parameters/wake_enabled
        chown -h radio.system /sys/module/qpnp_int/parameters/debug_mask
        chown -h radio.system /sys/module/lpm_levels/parameters/secdebug
        chmod -h 664 /sys/module/qpnp_power_on/parameters/reset_enabled
        chmod -h 664 /sys/module/qpnp_power_on/parameters/wake_enabled
        chmod -h 664 /sys/module/qpnp_int/parameters/debug_mask
        chmod -h 664 /sys/module/lpm_levels/parameters/secdebug
        chmod -h 444 /sys/kernel/wakeup_reasons/last_resume_reason

        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "206" | "247" | "248" | "249" | "250")
		echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
	        echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
	        echo 1 > /sys/devices/system/cpu/cpu3/online
	    ;;
           "239" | "241" | "263" | "268" | "269" | "270" | "271")
		echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
		echo 10 > /sys/class/net/rmnet0/queues/rx-0/rps_cpus
            ;;
             "233" | "240" | "242")
		echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
	        echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
	        echo 1 > /sys/devices/system/cpu/cpu3/online
	    ;;
       esac
    ;;
esac

case "$target" in
    "msm8916")

        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        # HMP scheduler settings for 8916, 8936, 8939, 8929
        echo 3 > /proc/sys/kernel/sched_window_stats_policy

        # Apply governor settings for 8916
        case "$soc_id" in
            "206" | "247" | "248" | "249" | "250")

                # HMP scheduler load tracking settings
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8916
                echo 50 > /proc/sys/kernel/sched_small_task
                echo 50 > /proc/sys/kernel/sched_mostly_idle_load
                echo 10 > /proc/sys/kernel/sched_mostly_idle_nr_run

		# disable thermal core_control to update scaling_min_freq
                echo 0 > /sys/module/msm_thermal/core_control/enabled
		echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/target_loads
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                chown -h system.system /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
                chown -h system.system /sys/class/devfreq/0.qcom,cpubw/min_freq
                chown -h system.system /sys/class/devfreq/0.qcom,cpubw/max_freq
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/target_loads
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                chmod -h 0660 /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
                chmod -h 0660 /sys/class/devfreq/0.qcom,cpubw/min_freq
                chmod -h 0660 /sys/class/devfreq/0.qcom,cpubw/max_freq

                product_name=`getprop ro.product.name`
                case "$product_name" in
                a3*)
                       echo "25000 1094400:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                       echo 99 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                       echo 25000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                       echo 800000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                       echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                       echo "85 800000:90 1094400:95" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                       echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                       echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
                       echo 40 >  /sys/class/kgsl/kgsl-3d0/idle_timer
                       ;;
                *)
                       echo "25000 1094400:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                       echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                       echo 25000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                       echo 998400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                       echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                       echo "1 200000:40 400000:50 533333:70 800000:82 998400:90 1094400:95 1209600:99" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                       echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                       echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis
                       echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                       ;;
                esac

                # Bring up all cores online
		echo 1 > /sys/devices/system/cpu/cpu1/online
	        echo 1 > /sys/devices/system/cpu/cpu2/online
	        echo 1 > /sys/devices/system/cpu/cpu3/online
	        echo 1 > /sys/devices/system/cpu/cpu4/online
            ;;
        esac

	# Apply governor settings for 8936
        case "$soc_id" in
            "233" | "240" | "242")

                # HMP scheduler load tracking settings
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8936
                echo 50 > /proc/sys/kernel/sched_small_task
                echo 50 > /proc/sys/kernel/sched_mostly_idle_load
                echo 10 > /proc/sys/kernel/sched_mostly_idle_nr_run

                # disable thermal core_control to update scaling_min_freq, interactive gov
                echo 0 > /sys/module/msm_thermal/core_control/enabled
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                echo "25000 1113600:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                echo 25000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                echo 960000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                echo "1 800000:85 1113600:90 1267200:80" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu4/online

                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
                do
                    echo 40 > $gpu_bimc_io_percent
                done
            ;;
        esac

        # Apply governor settings for 8939
        case "$soc_id" in
            "239" | "241" | "263" | "268" | "269" | "270" | "271")

                # HMP scheduler load tracking settings
                echo 5 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8939, 8929
                echo 30 > /proc/sys/kernel/sched_small_task
                echo 50 > /proc/sys/kernel/sched_mostly_idle_load
                echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run

                if [ "$soc_id" == "0" ]; then
                    for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
                    do
                        echo "bw_hwmon" > $devfreq_gov
                        for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
                        do
                            echo 20 > $cpu_io_percent
                        done
                    done
                else
                    # Bus-DCVS settings
                    echo "bw_hwmon" > /sys/class/devfreq/0.qcom,cpubw/governor
                    echo 16 > /sys/class/devfreq/0.qcom,cpubw/bw_hwmon/io_percent
                    echo 20 > /sys/class/devfreq/0.qcom,cpubw/polling_interval

                    chown -h system.system /sys/class/devfreq/0.qcom,cpubw/governor
                    chown -h system.system /sys/class/devfreq/0.qcom,cpubw/bw_hwmon/io_percent
                    chown -h system.system /sys/class/devfreq/0.qcom,cpubw/polling_interval
                    chown -h system.system /sys/class/devfreq/0.qcom,cpubw/max_freq
                    chown -h system.system /sys/class/devfreq/0.qcom,cpubw/min_freq
                    chmod -h 0660 /sys/class/devfreq/0.qcom,cpubw/governor
                    chmod -h 0660 /sys/class/devfreq/0.qcom,cpubw/bw_hwmon/io_percent
                    chmod -h 0660 /sys/class/devfreq/0.qcom,cpubw/polling_interval
                    chmod -h 0664 /sys/class/devfreq/0.qcom,cpubw/max_freq
                    chmod -h 0664 /sys/class/devfreq/0.qcom,cpubw/min_freq
                fi

                for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
                do
                    echo "powersave" > $devfreq_gov
                    for timeout in	/sys/class/devfreq/qcom,mincpubw*/cpufreq/timeout
                    do
                        echo 20 > $timeout
                    done
                done

                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
                do
                    echo 40 > $gpu_bimc_io_percent
                done

                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
                chown -h system.system /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
                chmod -h 0660 /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq

                # disable thermal core_control to update interactive gov settings
                echo 0 > /sys/module/msm_thermal/core_control/enabled

                # enable governor for perf cluster
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo "25000 1100000:50000 1300000:25000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                echo 99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                echo 25000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                echo 2000000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq
                echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                echo "85 850000:80 1000000:95" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
                echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
                echo 2000000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/lpm_disable_freq

                # Set governor parameters for power cluster
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
                chown -h system.system /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
                chmod -h 0660 /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq

                # enable governor for power cluster
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
                echo "25000 800000:50000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                echo 25000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq
                echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                echo "85 800000:90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                echo 499200 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
                echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
                echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/lpm_disable_freq

                echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
                echo 400000 > /proc/sys/kernel/sched_freq_dec_notify

                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo 1 > /sys/devices/system/cpu/cpu5/online
                echo 1 > /sys/devices/system/cpu/cpu6/online
                echo 1 > /sys/devices/system/cpu/cpu7/online
                chown -h root.system /sys/devices/system/cpu/cpu0/online
                chown -h root.system /sys/devices/system/cpu/cpu1/online
                chown -h root.system /sys/devices/system/cpu/cpu2/online
                chown -h root.system /sys/devices/system/cpu/cpu3/online
                chown -h root.system /sys/devices/system/cpu/cpu4/online
                chown -h root.system /sys/devices/system/cpu/cpu5/online
                chown -h root.system /sys/devices/system/cpu/cpu6/online
                chown -h root.system /sys/devices/system/cpu/cpu7/online
                chmod -h 664 /sys/devices/system/cpu/cpu0/online
                chmod -h 664 /sys/devices/system/cpu/cpu1/online
                chmod -h 664 /sys/devices/system/cpu/cpu2/online
                chmod -h 664 /sys/devices/system/cpu/cpu3/online
                chmod -h 664 /sys/devices/system/cpu/cpu4/online
                chmod -h 664 /sys/devices/system/cpu/cpu5/online
                chmod -h 664 /sys/devices/system/cpu/cpu6/online
                chmod -h 664 /sys/devices/system/cpu/cpu7/online

                echo Y > /sys/module/lpm_levels/system/power/power-l2-active/idle_enabled
                echo Y > /sys/module/lpm_levels/system/power/power-l2-pc/idle_enabled
                echo Y > /sys/module/lpm_levels/system/performance/performance-l2-active/idle_enabled
                echo Y > /sys/module/lpm_levels/system/performance/performance-l2-pc/idle_enabled
                echo Y > /sys/module/lpm_levels/system/power/power-l2-pc/suspend_enabled
                echo Y > /sys/module/lpm_levels/system/performance/performance-l2-pc/suspend_enabled
                echo Y > /sys/module/lpm_levels/system/system-cci-active/idle_enabled
                echo Y > /sys/module/lpm_levels/system/system-cci-retention/idle_enabled
                echo Y > /sys/module/lpm_levels/system/system-cci-pc/idle_enabled
                echo Y > /sys/module/lpm_levels/system/system-cci-pc/suspend_enabled

                # HMP scheduler (big.Little cluster related) settings
                echo 90 > /proc/sys/kernel/sched_upmigrate
                echo 70 > /proc/sys/kernel/sched_downmigrate
                echo 30 > /proc/sys/kernel/sched_init_task_load
                echo 10 > /proc/sys/kernel/sched_upmigrate_min_nice

                # cpu idle load threshold
                echo 30 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load
                echo 960000 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_freq
                echo 960000 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_freq
                echo 960000 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_freq
                echo 960000 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_freq
                rm /data/system/default_values
                echo 1 > /proc/sys/kernel/sched_boot_complete
            ;;
        esac
    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

# Post-setup services
case "$target" in
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case $soc_id in
            "239" | "241" | "263" | "268" | "269" | "270" | "271")
            setprop ro.min_freq_0 533333
            setprop ro.min_freq_4 499200
	    ;;
	    "206" | "247" | "248" | "249" | "250" | "233" | "240" | "242")
            setprop ro.min_freq_0 800000
        ;;
        esac
        #start perfd after setprop
        start perfd # start perfd on 8916, 8939 and 8929
    ;;
esac

case "$target" in
    "msm8226" | "msm8974" | "msm8610" | "apq8084" | "mpq8092" | "msm8610" | "msm8916" | "msm8994")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac

# Create native cgroup and move all tasks to it. Allot 15% real-time
# bandwidth limit to native cgroup (which is what remains after
# Android uses up 80% real-time bandwidth limit). root cgroup should
# become empty after all tasks are moved to native cgroup.

CGROUP_ROOT=/dev/cpuctl
mkdir $CGROUP_ROOT/native
echo 150000 > $CGROUP_ROOT/native/cpu.rt_runtime_us

# We could be racing with task creation, as a result of which its possible that
# we may fail to move all tasks from root cgroup to native cgroup in one shot.
# Retry few times before giving up.

for loop_count in 1 2 3
do
	for i in $(cat $CGROUP_ROOT/tasks)
	do
		echo $i > $CGROUP_ROOT/native/tasks
	done

	root_tasks=$(cat $CGROUP_ROOT/tasks)
	if [ -z "$root_tasks" ]
	then
		break
	fi
done

# Check if we failed to move all tasks from root cgroup
if [ ! -z "$root_tasks" ]
then
	echo "Error: Could not move all tasks to native cgroup"
fi
