require 'unicorn/worker_killer'

check_cycle = 16
verbose_flg = false

max_request_min = (ENV['MAX_REQUEST_MIN'] || 512).to_i
max_request_max = (ENV['MAX_REQUEST_MAX'] || 1024).to_i

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max, verbose_flg

oom_min = (ENV['OOM_MIN'] || 192).to_i * (1024 ** 2)
oom_max = (ENV['OOM_MAX'] || 256).to_i * (1024 ** 2)

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, oom_min, oom_max, check_cycle, verbose_flg

require_relative 'config/environment'
run Rails.application
