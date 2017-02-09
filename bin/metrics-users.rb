#! /usr/bin/env ruby
#  encoding: UTF-8
#   <script name>
#
# DESCRIPTION:
#   This plugin uses who command to collect metrics
#   Basically copied from sensu-plugins/sensu-plugins-users-checks
#
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux, BSD, Solaris, etc
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

class LoadStat < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: Socket.gethostname.to_s

  def run
    result = `who | awk '{print $1}'| sort -u | wc -l`.delete!("\n")

    timestamp = Time.now.to_i
    metrics = {
      users_qty: result
    }

    metrics.each do |key, value|
      output [config[:scheme], key].join('.'), value, timestamp
    end
    ok
  end
end
