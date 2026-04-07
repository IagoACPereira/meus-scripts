import {promisify} from 'util';
import {exec} from 'child_process';
import chalk from 'chalk';

class CommandExec {
    #execPromise;

    constructor(execPromise) {
        this.#execPromise = execPromise;
    }

    async run(command) {
        console.log(chalk.blueBright('Executando comando:'), command);
        
        try {
            const { stdout, stderr } = await this.#execPromise(command);

            if (stderr) {
                console.error(chalk.redBright(`Erro no comando: ${stderr}`));
            }

            console.log(chalk.whiteBright(`${stdout}`));
            return stdout;
        } catch (error) {
            console.error(chalk.redBright(`Erro na execução: ${error.message}`));
            throw error;
        }
    }
}

export const commandExec = new CommandExec(promisify(exec));