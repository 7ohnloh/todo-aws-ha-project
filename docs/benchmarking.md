# Benchmarking

Benchmark only infrastructure that you own and only at a responsible request rate.

## ApacheBench

Install ApacheBench, replace `ALB_DNS`, and run:

```bash
ab -n 100 -c 10 http://ALB_DNS/
```

- `-n 100` sends 100 total requests.
- `-c 10` keeps up to 10 requests active at the same time.
- **Requests per second** estimates throughput.
- **Time per request** estimates response delay.
- **Failed requests** should normally be zero.

Start with a small test. Compare results at different concurrency levels and watch CloudWatch while the test runs.

## Simple curl Test

```bash
curl -s -o /dev/null -w "HTTP %{http_code} in %{time_total}s\n" http://ALB_DNS/
```

PowerShell alternative:

```powershell
1..20 | ForEach-Object { (Measure-Command { Invoke-WebRequest http://ALB_DNS/ | Out-Null }).TotalMilliseconds }
```

## Relationship to Scalability and Availability

Benchmarking gives evidence about how the application responds when several users arrive together. As load rises, CPU utilization, target response time, and request count may increase. The ASG can add EC2 instances, while the ALB spreads requests across healthy targets. A useful demonstration is to compare metrics before, during, and after a controlled test.

Benchmark results depend on network conditions, database performance, instance type, and whether new instances have finished starting. They are observations, not guaranteed production capacity.
