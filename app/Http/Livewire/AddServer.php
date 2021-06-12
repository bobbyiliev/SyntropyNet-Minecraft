<?php

namespace App\Http\Livewire;

use Symfony\Component\Process\Process;
use Livewire\Component;

class AddServer extends Component
{
    public $locked;
    public $log;

    public function addNewServer()
    {

        if($this->locked == true){
            return;
        }

        Process::fromShellCommandline('bash ' . base_path().'/infrastructure/debug.sh')->start();

    }

    public function readLogFile()
    {
        $content = file_get_contents(base_path().'/infrastructure/status.lock');
        if(trim($content) == "DONE" || empty($content)){
            $this->locked = false;
        } else {
            $this->locked = true;
        }
        $this->log = $content;
    }

    public function render()
    {
        $this->readLogFile();
        return view('livewire.add-server');
    }
}
