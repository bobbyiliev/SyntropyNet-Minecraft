<?php

namespace App\Http\Livewire;

use Symfony\Component\Process\Process;
use Livewire\Component;
use Symfony\Component\Yaml\Yaml;

class ServersList extends Component
{

    public $servers;
    public $proxyServer;
    public $locked;
    public $log;

    public function removeServer($name, $debug = null)
    {

        if($this->locked == true){
            return;
        }

        $this->locked = true;

        if($debug){
            Process::fromShellCommandline('bash ' . base_path().'/infrastructure/debug.sh ' . $name)->start();    
            return;
        }

        Process::fromShellCommandline('bash ' . base_path().'/infrastructure/remove.sh ' . $name)->start();

    }

    public function readLogFile()
    {
        $content = file_get_contents(base_path().'/infrastructure/remove.lock');
        if(trim($content) == "DONE" || empty($content)){
            $this->locked = false;
        } else {
            $this->locked = true;
        }
        $this->log = $content;
    }

    public function getServers()
    {
        $proxyConfig = Yaml::parse(file_get_contents(base_path().'/infrastructure/config.yml'));
        $this->servers = $proxyConfig['servers'];
    }

    public function mount()
    {
        $this->proxyServer = $_SERVER['SERVER_ADDR'];
        $proxyConfig = Yaml::parse(file_get_contents(base_path().'/infrastructure/config.yml'));
        $this->servers = $proxyConfig['servers'];
    }

    public function render()
    {
        $this->readLogFile();
        return view('livewire.servers-list');
    }
}
