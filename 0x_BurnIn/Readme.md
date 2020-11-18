# Burn in scenarios

Why do a burn in? Software and thus Quobyte runs usually fine once it is installed. But if you are accountable for infrastructure you want to see how it behaves under pressure and over time; that is what these scenarios are thought for.

## 01. Load over time

We want to see if our storage is stable over time; so we are putting constant load on the system and monitor it over time. 
It is really useful to have a Prometheus setup (Chapter 03) already installed to watch out for changes.
Goal: See storage characterisics for example during different health manager tasks.

## 02. High pressure

With tis example we try to figure out how the cluster behaves if we put (possibly insane) high pressure on it. 
We will sclae out our clients and demand a mixed workload from the cluster. 
Goal: find the limits where sane operational conditions are given for your storage environment.


