<?php

namespace App\Http\Livewire;

use Symfony\Component\Process\Process;
use Livewire\Component;
use Symfony\Component\Yaml\Yaml;

class ServersList extends Component
{

    public $servers;
    public $proxyServer;

    public function removeServer($name)
    {

        //To do:
        // Remove the link from Syntropy
        // Delete the Server from DO
        // Remove from the config file

        // $process = new Process(['bash', base_path().'/infrastructure/remove.sh']);
        // $process->run();

        // $this->servers = $process->getOutput();
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
        return view('livewire.servers-list');
    }
}
